{
  autoAddDriverRunpath,
  autoPatchelfHook,
  bazel_7,
  buildBazelPackage,
  callPackage,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  elfutils,
  fetchFromGitHub,
  file,
  gitMinimal,
  glibc,
  lib,
  libxml2,
  ncurses,
  ncurses5,
  patchelf,
  python3,
  rdma-core,
  stdenv,
  which,
  writeText,
  zlib,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ numpy ]);

  # XLA's compute_* spelling emits both SASS and PTX; sm_* emits only SASS.
  # Keep the selected package set's ordering and forward-compatibility policy.
  cudaCapabilities =
    let
      inherit (cudaPackages.flags) realArches virtualArches cudaForwardCompat;
      arches =
        if cudaForwardCompat then lib.init realArches ++ [ (lib.last virtualArches) ] else realArches;
    in
    assert lib.assertMsg
      (lib.all (arch: builtins.match "(sm_|compute_)[0-9]{2,3}a?" arch != null) arches)
      "xla: the pinned CUDA rules do not support these cudaCapabilities (including family-specific f suffixes)";
    lib.concatStringsSep "," arches;

  cudaManifests = { inherit (cudaPackages.manifests) cuda cudnn; };
  cudaManifestHash = builtins.hashString "sha256" (builtins.toJSON cudaManifests);
  cudaLocal = callPackage ./cuda-local.nix { inherit cudaPackages; };

  # Keep a real build-only driver, not a toolkit stub, for CUDA-linked exec
  # tools. CCCL has its own LOCAL_CCCL_PATH hook and stays pinned by XLA.
  # The inner toJSON serializes manifest data for json.decode; the outer one
  # quotes and escapes that text as a Starlark string literal.
  cudaRedistributions = writeText "xla-cuda-redistributions.bzl" ''
    load("@rules_ml_toolchain//gpu/cuda:cuda_redist_versions.bzl", "REDIST_VERSIONS_TO_BUILD_TEMPLATES")
    CUDA_REDISTRIBUTIONS = json.decode(${builtins.toJSON (builtins.toJSON cudaManifests.cuda)})
    CUDNN_REDISTRIBUTIONS = json.decode(${builtins.toJSON (builtins.toJSON cudaManifests.cudnn)})
    NIX_CUDA_TEMPLATES = dict(REDIST_VERSIONS_TO_BUILD_TEMPLATES)
    NIX_CUDA_TEMPLATES["nvidia_driver"] = dict(NIX_CUDA_TEMPLATES["nvidia_driver"])
    NIX_CUDA_TEMPLATES["nvidia_driver"]["local"] = dict(NIX_CUDA_TEMPLATES["nvidia_driver"]["local"], local_path_env_var = "XLA_LOCAL_DRIVER_PATH")
  '';

  # Omit selected-output-backed repositories and generated CUDA configuration
  # from the relocatable FOD. Bazel regenerates them offline with the real paths.
  # Keep local_config_nccl: its path-independent aliases cannot be recreated by
  # Bazel 7 from the restored archive, and resolve through regenerated cuda_nccl.
  localCudaRepositories = [
    "cuda_cublas"
    "cuda_cudart"
    "cuda_cufft"
    "cuda_cupti"
    "cuda_curand"
    "cuda_cusolver"
    "cuda_cusparse"
    "cuda_nvjitlink"
    "cuda_nvrtc"
    "cuda_crt"
    "cuda_nvcc"
    "cuda_nvvm"
    "cuda_nvdisasm"
    "cuda_nvml"
    "cuda_nvprune"
    "cuda_profiler_api"
    "cuda_nvtx"
    "cuda_cudnn"
    "cuda_nccl"
    "local_config_cuda"
  ];
  removeLocalCudaRepositories = ''
    for repository in ${lib.escapeShellArgs localCudaRepositories}; do
      rm -rf "$bazelOut/external/$repository" "$bazelOut/external/@$repository.marker"
    done
  '';

  configureCuda = capabilities: ''
    ${lib.getExe pythonEnv} ./configure.py \
      --backend=CUDA \
      --host_compiler=CLANG \
      --cuda_compiler=NVCC \
      --cuda_compute_capabilities=${capabilities} \
      --cuda_version=${cudaManifests.cuda.release_label} \
      --cudnn_version=${cudaManifests.cudnn.release_label} \
      --local_cuda_path=${cudaLocal.cuda} \
      --local_cudnn_path=${cudaLocal.cudnn} \
      --local_nccl_path=${cudaLocal.nccl} \
      --nccl
  '';

  hostRpath = lib.makeLibraryPath [
    glibc
    stdenv.cc.cc.lib
    zlib
  ];

  # Omit nixpkgs' NVSHMEM 3.6.5-0: its IBRC transport has SONAME 5, while
  # the existing CUDA 12 build with NVSHMEM 3.2.5 needs SONAME 3 (host and
  # bootstrap remain SONAME 3 in both versions). Install matching DSOs below;
  # a coherent newer build/runtime migration has not been validated.
  cudaRuntimeLibs = lib.optionals cudaSupport (
    (with cudaPackages; [
      (lib.getLib cuda_cudart)
      (lib.getLib cuda_cupti)
      (lib.getLib libcublas)
      (lib.getLib libcufft)
      (lib.getLib libcurand)
      (lib.getLib libcusolver)
      (lib.getLib libcusparse)
      (lib.getLib cudnn)
      (lib.getLib nccl)
      (lib.getLib cuda_nvrtc)
      (lib.getLib libnvjitlink)
    ])
    ++ [ (lib.getLib rdma-core) ]
  );
in
(buildBazelPackage {
  pname = "xla";
  version = "0-unstable-2026-02-21";

  src = fetchFromGitHub {
    owner = "openxla";
    repo = "xla";
    rev = "964a0a45a0c3090cd484a3c51e8f9d05ed10b968";
    hash = "sha256-K0lveAY1nXeFA9FIV3nXhEJ0r589CNaVp/M5heUo1BY=";
  };

  bazel = bazel_7; # from .bazelversion

  nativeBuildInputs = [
    gitMinimal
    patchelf
    pythonEnv
    which
  ];

  postPatch =
    # Remove the .bazelversion file to allow our Bazel version
    ''
      rm -f .bazelversion
      patchShebangs .
    ''
    # Remove @pypi//lit dependencies that trigger rules_python's hermetic
    # Python download for lit test targets (only needed for running lit tests,
    # not building)
    + ''
      substituteInPlace xla/lit.bzl \
        --replace-fail '"@pypi//lit",' "" \
        --replace-fail 'if_oss(["@pypi//lit"])' "[]"
      substituteInPlace xla/mlir_hlo/tests/BUILD \
        --replace-fail 'deps = ["@pypi//lit"],' ""
    ''
    # Hermetic Python patchelf workaround:
    #
    # XLA uses rules_python's hermetic Python toolchain, which downloads a
    # pre-built CPython binary (from python-build-standalone). This binary
    # hardcodes /lib64/ld-linux-x86-64.so.2 as its dynamic linker, which
    # doesn't exist in the nix sandbox.
    #
    # During the deps fetch phase, Bazel's `python_repository` rule downloads
    # the binary, and then a separate `host_toolchain` rule (creating
    # python_3_X_host) tries to *execute* it to verify it works. This fails
    # without patchelf.
    #
    # The patchelf must happen inside the `python_repository` rule itself
    # (between download and verification) -- there is no Bazel hook or nix
    # phase we can use between these two repository rules. So we patch
    # rules_python's python_repository.bzl to run patchelf right after
    # extracting the binary, using NIX_DYNAMIC_LINKER from --repo_env.
    #
    # In the build phase, fetchAttrs.installPhase normalizes all /nix/store
    # paths for reproducibility (breaking the patchelf), so
    # buildAttrs.postConfigure re-patchelfs the binary for the actual build.
    + ''
      cp ${./rules-python-nix-patchelf.patch} third_party/py/rules_python_nix_patchelf.patch
      substituteInPlace third_party/py/python_init_rules.bzl \
        --replace-fail \
          '] + extra_patches,' \
          '"@xla//third_party/py:rules_python_nix_patchelf.patch",
          ] + extra_patches,'
    ''
    # Pin gRPC's rules_go SDK metadata. Without `sdks`, rules_go downloads the
    # live Go release manifest into @go_sdk/versions.json, making the deps tar
    # change whenever go.dev publishes a new release.
    + ''
      cp ${./grpc-pin-go-sdk.patch} third_party/grpc/grpc-pin-go-sdk.patch
      substituteInPlace workspace2.bzl \
        --replace-fail \
          'patch_file = ["//third_party/grpc:grpc.patch"],' \
          'patch_file = [
            "//third_party/grpc:grpc.patch",
            "//third_party/grpc:grpc-pin-go-sdk.patch",
          ],'
    ''
    # Local hooks consume selected processed outputs, including downstream
    # patches. Metadata still supplies the build-only driver and upstream extras;
    # bypass the older JSON lookup without changing XLA's CCCL 3.2.0 override.
    + lib.optionalString cudaSupport ''
      cp ${cudaRedistributions} nix_cuda_redist.bzl
      substituteInPlace WORKSPACE \
        --replace-fail 'cuda_json_init_repository()' "" \
        --replace-fail '"@cuda_redist_json//:distributions.bzl"' '"//:nix_cuda_redist.bzl", "NIX_CUDA_TEMPLATES"' \
        --replace-fail 'REDIST_VERSIONS_TO_BUILD_TEMPLATES | CCCL_GITHUB_VERSIONS_TO_BUILD_TEMPLATES' \
          'NIX_CUDA_TEMPLATES | CCCL_GITHUB_VERSIONS_TO_BUILD_TEMPLATES'
    '';

  # Omitting --clang_path selects XLA's rules_ml_toolchain Clang 18 toolchain.
  preConfigure =
    if cudaSupport then
      configureCuda cudaCapabilities
    else
      ''
        ${lib.getExe pythonEnv} ./configure.py \
          --backend=CPU \
          --host_compiler=CLANG
      '';

  bazelTargets = [
    "//xla/..."
  ];

  # Tests are disabled - most XLA tests are skipped in OSS builds due to tag
  # filters and size constraints. See https://github.com/openxla/xla/issues/36756.

  bazelFlags = [
    "-c"
    "opt"
    # Bazel's nested sandbox cannot reliably execute downloaded hermetic tools;
    # the outer Nix build sandbox still isolates local actions.
    "--spawn_strategy=local"
    "--genrule_strategy=local"
    # Disable bzlmod - XLA uses WORKSPACE for deps and bzlmod would try to
    # access the Bazel Central Registry during the build phase.
    "--noenable_bzlmod"
    # Work around missing includes in bundled LLVM headers.
    "--cxxopt=-include"
    "--cxxopt=cstdint"
    "--host_cxxopt=-include"
    "--host_cxxopt=cstdint"
    # Exec-configuration tools are linked against the hermetic Ubuntu sysroot;
    # give them the NixOS dynamic linker so Bazel can execute them.
    "--host_linkopt=-Wl,--dynamic-linker=${stdenv.cc.bintools.dynamicLinker}"
    "--host_linkopt=-Wl,-rpath,${hostRpath}"
    # Exclude targets that have incompatibilities.
    "--build_tag_filters=-mobile,-ios,-no_oss${
      if cudaSupport then ",-rocm-only,-oneapi-only" else ",-gpu"
    }"
    # Dynamic linker path for patchelf in rules-python-nix-patchelf.patch.
    "--repo_env=NIX_DYNAMIC_LINKER=${stdenv.cc.bintools.dynamicLinker}"
  ]
  ++
    lib.optional cudaSupport
      # Bazel 7 resets Starlark flags for exec-configured tools. Use the legacy
      # define that preConfigure maps to rules_ml_toolchain's CUDA settings.
      "--define=using_cuda_nvcc=true";

  # The registered rules_ml toolchain provides its own compiler and sysroot.
  dontAddBazelOpts = true;

  removeRulesCC = false;
  removeLocal = false;

  fetchAttrs = {
    # nccl_archive is first requested after actions start, while the fixed-output
    # fetch uses `build --nobuild`; force it into the offline repository archive.
    bazelTargets = [ "//xla/..." ] ++ lib.optional cudaSupport "@nccl_archive//...";

    sha256 =
      {
        cpu.x86_64-linux = "sha256-wbLvzCLpFw4+QF86zIBroAeFrwqUTe31aJV7tcjhSZE=";
        # This hash covers the selected manifests, not cudaCapabilities. Alternate
        # manifests need a caller-supplied deps outputHash/outputHashAlgo override.
        cuda.x86_64-linux =
          if cudaManifestHash == "41d8c351dd9ceb95086c8fc2ebcb49b317c5082393220e5919372a7860487c60" then
            "sha256-BXPlzvYSCOudbKgHU/IhHaHG5umNBGgD0hKl7jnOxcc="
          else
            throw "xla: no Bazel dependency hash for these CUDA/cuDNN manifests; overrideAttrs with deps.overrideAttrs { outputHash = ...; outputHashAlgo = \"sha256\"; } (see tests/README.md)";
      }
      .${if cudaSupport then "cuda" else "cpu"}.${stdenv.hostPlatform.system}
        or (throw "unsupported system: ${stdenv.hostPlatform.system}");

    # buildBazelPackage normally removes every top-level symlink. Preserve
    # directory aliases used by hermetic LLVM, sysroot, and CUDA repositories.
    # Repository archives can contain read-only directories and symlinks.
    # Normalize the fully materialized archive tree only after repository
    # aliases have been copied into it.
    installPhase = ''
      runHook preInstall

      ${lib.optionalString cudaSupport removeLocalCudaRepositories}chmod -R +w "$bazelOut/external"

      rm -rf $bazelOut/external/{bazel_tools,\@bazel_tools.marker}
      rm -rf $bazelOut/external/{embedded_jdk,\@embedded_jdk.marker}
      rm -rf $bazelOut/external/{local_config_cc,\@local_config_cc.marker}
      rm -rf $bazelOut/external/{local_config_python,\@local_config_python.marker}
      rm -rf $bazelOut/external/{local_config_sh,\@local_config_sh.marker}
      rm -rf $bazelOut/external/{local_config_xcode,\@local_config_xcode.marker}
      rm -rf $bazelOut/external/{local_execution_config_python,\@local_execution_config_python.marker}
      rm -rf $bazelOut/external/{local_jdk,\@local_jdk.marker}

      find $bazelOut/external -name '@*\.marker' -exec sh -c 'echo > {}' \;
      rm -rf $(find $bazelOut/external -type d -name .git)
      rm -rf $(find $bazelOut/external -type d -name .svn)
      rm -rf $(find $bazelOut/external -type d -name .hg)

      find $bazelOut/external -maxdepth 1 -type l | while read -r symlink; do
        target="$(readlink -f "$symlink")"
        if [ -d "$target" ]; then
          rm "$symlink"
          cp -rL "$target" "$symlink"
        else
          name="$(basename "$symlink")"
          rm "$symlink"
          test ! -f "$bazelOut/external/@$name.marker" || rm "$bazelOut/external/@$name.marker"
        fi
      done

      find $bazelOut/external -type l | while read -r symlink; do
        new_target="$(readlink "$symlink" | sed "s,$NIX_BUILD_TOP,NIX_BUILD_TOP,")"
        rm "$symlink"
        ln -sf "$new_target" "$symlink"
      done

      chmod -R +w "$bazelOut/external"
      find "$bazelOut/external" -type f -exec \
        sed -i 's|/nix/store/[a-z0-9]\{32\}-|/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-|g' {} +
      find "$bazelOut/external" -name '*.pyc' -delete

      remaining_store_refs="$(
        {
          find "$bazelOut/external" -type f -exec \
            grep -aohE '/nix/store/[a-z0-9]{32}-' {} + \
            || true
          find "$bazelOut/external" -type l -exec readlink {} \; \
            | grep -oE '/nix/store/[a-z0-9]{32}-' \
            || true
        } \
          | grep -vFx '/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-' \
          | sort -u \
          || true
      )"
      if [ -n "$remaining_store_refs" ]; then
        printf '%s\n' "$remaining_store_refs" >&2
        echo "un-normalized Nix store reference in Bazel dependency archive" >&2
        exit 1
      fi

      echo '${bazel_7.name}' > $bazelOut/external/.nix-bazel-version
      (cd "$bazelOut" && \
        tar cf "$out" \
          --sort=name \
          --mtime='@1' \
          --owner=0 \
          --group=0 \
          --numeric-owner \
          external/)

      runHook postInstall
    '';
  }
  // lib.optionalAttrs cudaSupport {
    # Fetch a capability-independent archive. The build discards and regenerates
    # local_config_cuda: Nix's Bazel otherwise trusts its fetch-time configuration.
    preConfigure = configureCuda "sm_80";
  };

  buildAttrs = {
    outputs = [ "out" ];

    __structuredAttrs = cudaSupport;
    strictDeps = cudaSupport;

    nativeBuildInputs = [
      autoPatchelfHook
      file
      gitMinimal
      patchelf
      pythonEnv
      which
    ]
    ++ lib.optional cudaSupport autoAddDriverRunpath;

    # Downloaded hermetic LLVM, Python, and CUDA tools are Ubuntu-built binaries.
    buildInputs = [
      elfutils
      glibc
      libxml2
      ncurses5
      ncurses
      stdenv.cc.cc.lib
      zlib
    ]
    ++ cudaRuntimeLibs;

    # Runtime compilation needs ptxas, nvlink, and libdevice. Use the selected
    # toolkit as XLA's default so clients need no toolkit PATH or XLA_FLAGS.
    # Explicit flags still override this default.
    # The pinned Bazel cannot propagate Starlark build settings through exec
    # transitions. Its legacy --define setting does propagate, so use that for
    # rules_ml_toolchain selection in both target and exec configurations.
    # The include scanner records physical targets of the local view's symlinked
    # headers. Treat immutable roots as compiler built-ins; compilation still
    # reaches them through Bazel's declared repositories.
    # CUDA-enabled exec tools link libcuda even when generating CPU artifacts.
    # Use the hermetic driver while running them during the build.
    postConfigure =
      lib.optionalString cudaSupport ''
        ${removeLocalCudaRepositories}

        substituteInPlace xla/debug_options_flags.cc \
          --replace-fail \
            'opts.set_xla_gpu_cuda_data_dir("./cuda_sdk_lib");' \
            'opts.set_xla_gpu_cuda_data_dir("${cudaPackages.cuda_nvcc}");'

        substituteInPlace $bazelOut/external/rules_ml_toolchain/common/BUILD \
          --replace-fail \
            'flag_values = {":enable_cuda": "True"},' \
            'define_values = {"using_cuda_nvcc": "true"},' \
          --replace-fail \
            'flag_values = {":enable_cuda": "False"},' \
            'define_values = {"using_cuda_nvcc": "false"},'

        substituteInPlace \
          $bazelOut/external/rules_ml_toolchain/third_party/rules_cc_toolchain/toolchain_config.bzl \
          --replace-fail \
            'abi_libc_version = "unknown",' \
            'abi_libc_version = "unknown",
        cxx_builtin_include_directories = ${
          builtins.toJSON (map (root: "${root}/include") cudaLocal.cudaRoots)
        },'

        echo \
          "build --action_env=LD_LIBRARY_PATH=${hostRpath}:$bazelOut/external/cuda_driver/lib" \
          >> xla_configure.bazelrc
      ''
      # Avoid a repository-cache validation refetch after marker normalization.
      + ''
        if [ -d "$bazelOut/external/riegeli" ]; then
          touch "$bazelOut/external/riegeli/WORKSPACE"
        fi

        substituteInPlace $bazelOut/external/rules_python/python/private/py_runtime_info.bzl \
          --replace-fail '"#!/usr/bin/env python3"' '"#!${pythonEnv}/bin/python3"'
        substituteInPlace $bazelOut/external/rules_python/python/private/stage1_bootstrap_template.sh \
          --replace-fail '#!/usr/bin/env bash' '#!${stdenv.shell}'
        substituteInPlace $bazelOut/external/rules_python/python/private/runtime_env_toolchain.bzl \
          --replace-fail '"#!/usr/bin/env python3"' '"#!${pythonEnv}/bin/python3"'

        patchShebangs "$bazelOut/external/rules_ml_toolchain"

        nix_rpath="${
          lib.makeLibraryPath [
            elfutils
            glibc
            libxml2
            ncurses5
            ncurses
            stdenv.cc.cc.lib
            zlib
          ]
        }"
        llvm_lib="$bazelOut/external/llvm18_linux_x86_64/lib"
        nix_rpath="$llvm_lib:$nix_rpath"

        for tool_dir in \
          "$bazelOut/external/llvm18_linux_x86_64" \
          "$bazelOut/external/llvm_linux_x86_64" \
          "$bazelOut/external/cuda_nvcc" \
          "$bazelOut/external/cuda_cupti" \
          "$bazelOut/external/xxd" \
          $bazelOut/external/python_3_*; do
          ${lib.optionalString cudaSupport ''
            case "$tool_dir" in
              */cuda_nvcc|*/cuda_cupti) continue ;;
            esac
          ''}if [ -d "$tool_dir" ]; then
            patchShebangs "$tool_dir"
            find "$tool_dir" -type f -executable -print0 | while IFS= read -r -d "" tool; do
              if file "$tool" | grep -q 'ELF.*dynamically linked'; then
                if patchelf --print-interpreter "$tool" >/dev/null 2>&1; then
                  patchelf --set-interpreter '${stdenv.cc.bintools.dynamicLinker}' "$tool"
                fi
                old_rpath="$(patchelf --print-rpath "$tool")"
                if [ -z "$old_rpath" ]; then
                  patchelf --set-rpath "$nix_rpath" "$tool"
                elif [[ ":$old_rpath:" != *":$nix_rpath:"* ]]; then
                  patchelf --set-rpath "$old_rpath:$nix_rpath" "$tool"
                fi
              fi
            done
          fi
        done
      '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{bin,lib,include}
    ''
    # Install built libraries. Preserve the existing flattened, last-copy-wins
    # behavior, but make the winner reproducible and allow read-only replacement.
    # libmlir_c_runner_utils.so records solib names for MLIR and LLVM dependencies
    # outside bazel-bin/xla. Flattening also picks up unusable runfiles manifests.
    + ''
      install_bazel_libraries() {
        find bazel-bin/xla -name "$1" -type f -print0 \
          | sort -z \
          | while IFS= read -r -d "" library; do
            cp --remove-destination "$library" "$out/lib/$(basename "$library")"
          done
      }
      install_bazel_libraries "*.so*"
      install_bazel_libraries "*.a"

      mlir_runner_libs=(
        libexternal_Sllvm-project_Smlir_Slib_Umlir_Uc_Urunner_Uutils.so
        libexternal_Sllvm-project_Smlir_SlibSparseTensorRuntime.so
        libexternal_Sllvm-project_Smlir_Slib_Umlir_Uapfloat_Uutils.so
        libexternal_Sllvm-project_Smlir_Slib_Umlir_Ufloat16_Uutils.so
        libexternal_Sllvm-project_Sllvm_SlibSupport.so
        libexternal_Sllvm-project_Sllvm_SlibDemangle.so
      )
      for library in "''${mlir_runner_libs[@]}"; do
        library_path="bazel-bin/_solib_x86_64/$library"
        if [ ! -e "$library_path" ]; then
          echo "missing Bazel runtime dependency $library_path" >&2
          exit 1
        fi
        cp -L "$library_path" "$out/lib/$library"
      done
      find "$out/lib" -name '*.runfiles_manifest' -delete
    ''
    # Install the matching NVSHMEM 3.2.5 runtime DSOs for the tested CUDA 12
    # build; its transport ABI predates nixpkgs' SONAME 5 NVSHMEM, which cannot
    # be substituted or aliased to SONAME 3 without validation.
    + lib.optionalString cudaSupport ''
      nvshmem_lib="$bazelOut/external/nvidia_nvshmem/lib"
      install -m755 \
        "$nvshmem_lib/libnvshmem_host.so.3.2.5" \
        "$nvshmem_lib/nvshmem_bootstrap_uid.so.3.0.0" \
        "$nvshmem_lib/nvshmem_transport_ibrc.so.3.0.0" \
        "$out/lib/"
      ln -s libnvshmem_host.so.3.2.5 "$out/lib/libnvshmem_host.so.3"
      ln -s nvshmem_bootstrap_uid.so.3.0.0 "$out/lib/nvshmem_bootstrap_uid.so.3"
      ln -s nvshmem_transport_ibrc.so.3.0.0 "$out/lib/nvshmem_transport_ibrc.so.3"
    ''
    # Install CLI tools
    + ''
      cp bazel-bin/xla/tools/run_hlo_module $out/bin/
    ''
    # Install headers
    + ''
      find xla -name "*.h" -type f | while read -r header; do
        target="$out/include/$header"
        mkdir -p "$(dirname "$target")"
        cp "$header" "$target"
      done

      runHook postInstall
    '';
  }
  // lib.optionalAttrs cudaSupport {
    # XLA and NVSHMEM load these libraries by bare soname rather than through
    # DT_NEEDED. The NVIDIA driver itself is supplied by the host at runtime.
    runtimeDependencies = cudaRuntimeLibs;
    autoPatchelfIgnoreMissingDeps = [ "libcuda.so.1" ];
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Machine learning compiler for GPUs, CPUs, and ML accelerators";
    homepage = "https://github.com/openxla/xla";
    license = [
      lib.licenses.asl20
    ]
    ++ lib.optionals cudaSupport ([ lib.licenses.nvidiaCudaRedist ] ++ cudaPackages.cudnn.meta.license);
    maintainers = with lib.maintainers; [ samuela ];
    platforms = [ "x86_64-linux" ];
  };
}).overrideAttrs
  # buildBazelPackage accepts only an attrset, not mkDerivation's finalAttrs callback.
  # overrideAttrs supplies finalPackage so tests follow downstream package overrides.
  (
    finalAttrs: previousAttrs:
    let
      checks = callPackage ./tests {
        xla = finalAttrs.finalPackage;
        inherit cudaSupport cudaPackages cudaRuntimeLibs;
      };
    in
    {
      passthru = (previousAttrs.passthru or { }) // {
        inherit cudaSupport;
        inherit (checks) tests testers;
      };
    }
  )
