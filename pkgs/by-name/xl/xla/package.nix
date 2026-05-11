{
  bazel_7,
  buildBazelPackage,
  fetchFromGitHub,
  gitMinimal,
  lib,
  llvmPackages_18,
  patchelf,
  python3,
  stdenv,
  which,
}:

let
  # XLA requires clang 18 -- gcc and newer clang versions (e.g., 21) fail with
  # stricter template syntax checks in xla/tsl/concurrency/async_value_ref.h
  #
  # ABI compatibility with other Nixpkgs stdenv-built packages can be confirmed
  # by seeing that
  #
  #   ldd $(nix-build -A xla)/lib/libservice.so 2>/dev/null | grep -E '(libstdc\+\+|libc\+\+)'
  #
  # shows libstdc++ as being linked from gcc.
  clangStdenv = llvmPackages_18.stdenv;

  pythonEnv = python3.withPackages (ps: with ps; [ numpy ]);
in
(buildBazelPackage.override { stdenv = clangStdenv; }) {
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
    # Remove rules_ml_toolchain's hermetic CC toolchain registrations.
    # These try to lazily download LLVM binaries (llvm18_linux_x86_64,
    # sysroot_linux_x86_64_glibc_2_27) during analysis, which fails in the
    # sandboxed build phase. We use our own clang from nixpkgs instead.
    + ''
      sed -i '/^register_toolchains("@rules_ml_toolchain/d' WORKSPACE
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
    # In the build phase, fetchAttrs.preInstall normalizes all /nix/store
    # paths for reproducibility (breaking the patchelf), so
    # buildAttrs.preConfigure re-patchelfs the binary for the actual build.
    + ''
      cp ${./rules-python-nix-patchelf.patch} third_party/py/rules_python_nix_patchelf.patch
      substituteInPlace third_party/py/python_init_rules.bzl \
        --replace-fail \
          '] + extra_patches,' \
          '"@xla//third_party/py:rules_python_nix_patchelf.patch",
          ] + extra_patches,'
    '';

  # Configure XLA for CPU-only build using the official configure.py script.
  # This creates a xla_configure.bazelrc file with the appropriate options.
  # Using clang which matches XLA CI environment.
  # Note: --python_bin_path only sets PYTHON_BIN_PATH; it does not disable
  # rules_python's hermetic Python download (triggered by python_init_toolchains).
  preConfigure = ''
    ${lib.getExe pythonEnv} ./configure.py \
      --backend=CPU \
      --host_compiler=CLANG \
      --clang_path=${lib.getExe clangStdenv.cc}
  '';

  bazelTargets = [
    "//xla/..."
  ];

  # Tests are disabled - most XLA tests are skipped in OSS builds due to tag
  # filters and size constraints. See https://github.com/openxla/xla/issues/36756.

  bazelFlags = [
    "-c opt"
    # Use sandboxed strategy for most actions, but allow local for genrules
    # and copy actions that have issues with strict sandboxing
    "--spawn_strategy=sandboxed,local"
    "--genrule_strategy=sandboxed,local"
    # Disable bzlmod - XLA uses WORKSPACE for deps and bzlmod would try to
    # access the Bazel Central Registry during the build phase
    "--noenable_bzlmod"
    # Work around missing includes in bundled LLVM headers
    "--cxxopt=-include"
    "--cxxopt=cstdint"
    "--host_cxxopt=-include"
    "--host_cxxopt=cstdint"
    # Exclude targets that have incompatibilities
    "--build_tag_filters=-mobile,-ios,-no_oss,-gpu"
    # Dynamic linker path for patchelf in rules-python-nix-patchelf.patch
    "--repo_env=NIX_DYNAMIC_LINKER=${clangStdenv.cc.libc}/lib/ld-linux-x86-64.so.2"

  ];

  removeRulesCC = false;
  # We need some local_config_* repos (CUDA, ROCm, TensorRT stubs) in the build
  # phase.
  removeLocal = false;

  fetchAttrs = {
    sha256 =
      {
        x86_64-linux = "sha256-QTUqcP5t91Z4s+esxxFz2tGJAJplWXWZuYPqcC7ld+E=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");
    preInstall =
      # Note: $bazelOut/external is the entire contents of the deps archive (see
      # `deps.installPhase` in buildBazelPackage).
      ''
        chmod -R +w $bazelOut/external
        rm -rf $bazelOut/external/{local_config_python,\@local_config_python.marker}
        rm -rf $bazelOut/external/{local_config_sh,\@local_config_sh.marker}
        rm -rf $bazelOut/external/{local_config_xcode,\@local_config_xcode.marker}
        rm -rf $bazelOut/external/{local_execution_config_python,\@local_execution_config_python.marker}
        rm -rf $bazelOut/external/{local_jdk,\@local_jdk.marker}
      ''
      # Normalize all /nix/store hashes to a fixed value so the deps archive is
      # reproducible regardless of which nixpkgs revision built it. Somehow this
      # does not break the build (yet).
      + ''
        find $bazelOut/external -type f -exec \
          sed -i 's|/nix/store/[a-z0-9]\{32\}-|/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-|g' {} +
      ''
      # Delete non-deterministic Python bytecode (contains timestamps)
      + ''
        find $bazelOut/external -name '*.pyc' -delete
      '';
  };

  buildAttrs = {
    outputs = [ "out" ];

    preConfigure =
      # Fix #!/usr/bin/env shebangs in rules_python -- Bazel-generated Python
      # stubs use #!/usr/bin/env which doesn't exist in the nix sandbox
      ''
        substituteInPlace $bazelOut/external/rules_python/python/private/py_runtime_info.bzl \
          --replace-fail '"#!/usr/bin/env python3"' '"#!${pythonEnv}/bin/python3"'
        substituteInPlace $bazelOut/external/rules_python/python/private/stage1_bootstrap_template.sh \
          --replace-fail '#!/usr/bin/env bash' '#!${clangStdenv.shell}'
        substituteInPlace $bazelOut/external/rules_python/python/private/runtime_env_toolchain.bzl \
          --replace-fail '"#!/usr/bin/env python3"' '"#!${pythonEnv}/bin/python3"'
      ''
      # Re-patchelf hermetic Python binary with the nix dynamic linker
      # (was normalized in fetchAttrs for reproducibility)
      + ''
        for py_dir in $bazelOut/external/python_3_*; do
          if [ -d "$py_dir" ]; then
            find "$py_dir" -type f -executable \
              -exec patchelf --set-interpreter ${clangStdenv.cc.libc}/lib/ld-linux-x86-64.so.2 {} \; 2>/dev/null || true
          fi
        done
      '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{bin,lib,include}
    ''
    # Install built libraries
    + ''
      find bazel-bin/xla -name "*.so*" -type f -exec cp {} $out/lib \;
      find bazel-bin/xla -name "*.a" -type f -exec cp {} $out/lib \;
    ''
    # Install CLI tools
    + ''
      cp bazel-bin/xla/tools/run_hlo_module $out/bin/
    ''
    # Install headers
    + ''
      find xla -name "*.h" -type f | while read header; do
        target="$out/include/$header"
        mkdir -p "$(dirname "$target")"
        cp "$header" "$target"
      done

      runHook postInstall
    '';
  };
  meta = {
    description = "Machine learning compiler for GPUs, CPUs, and ML accelerators";
    homepage = "https://github.com/openxla/xla";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
    platforms = [
      "x86_64-linux"

    ];
  };
}
