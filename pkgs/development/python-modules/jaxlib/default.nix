{ lib
, pkgs
, stdenv

  # Build-time dependencies:
, addOpenGLRunpath
, autoAddDriverRunpath
, bazel_6
, binutils
, buildBazelPackage
, buildPythonPackage
, cctools
, curl
, cython
, fetchFromGitHub
, fetchpatch
, git
, IOKit
, jsoncpp
, nsync
, openssl
, pybind11
, setuptools
, symlinkJoin
, wheel
, build
, which

  # Python dependencies:
, absl-py
, flatbuffers
, ml-dtypes
, numpy
, scipy
, six

  # Runtime dependencies:
, double-conversion
, giflib
, libjpeg_turbo
, python
, snappy
, zlib

, config
  # CUDA flags:
, cudaSupport ? config.cudaSupport
, cudaPackagesGoogle

  # MKL:
, mklSupport ? true
}@inputs:

let
  inherit (cudaPackagesGoogle) cudaFlags cudaVersion cudnn nccl;

  pname = "jaxlib";
  version = "0.4.24";

  # It's necessary to consistently use backendStdenv when building with CUDA
  # support, otherwise we get libstdc++ errors downstream
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackagesGoogle.backendStdenv else inputs.stdenv;

  meta = with lib; {
    description = "JAX is Autograd and XLA, brought together for high-performance machine learning research.";
    homepage = "https://github.com/google/jax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
    platforms = platforms.unix;
    # aarch64-darwin is broken because of https://github.com/bazelbuild/rules_cc/pull/136
    # however even with that fix applied, it doesn't work for everyone:
    # https://github.com/NixOS/nixpkgs/pull/184395#issuecomment-1207287129
    # NOTE: We always build with NCCL; if it is unsupported, then our build is broken.
    broken = effectiveStdenv.isDarwin || nccl.meta.unsupported;
  };

  # These are necessary at build time and run time.
  cuda_libs_joined = symlinkJoin {
    name = "cuda-joined";
    paths = with cudaPackagesGoogle; [
      cuda_cudart.lib # libcudart.so
      cuda_cudart.static # libcudart_static.a
      cuda_cupti.lib # libcupti.so
      libcublas.lib # libcublas.so
      libcufft.lib # libcufft.so
      libcurand.lib # libcurand.so
      libcusolver.lib # libcusolver.so
      libcusparse.lib # libcusparse.so
    ];
  };
  # These are only necessary at build time.
  cuda_build_deps_joined = symlinkJoin {
    name = "cuda-build-deps-joined";
    paths = with cudaPackagesGoogle; [
      cuda_libs_joined

      # Binaries
      cudaPackagesGoogle.cuda_nvcc.bin # nvcc

      # Headers
      cuda_cccl.dev # block_load.cuh
      cuda_cudart.dev # cuda.h
      cuda_cupti.dev # cupti.h
      cuda_nvcc.dev # See https://github.com/google/jax/issues/19811
      cuda_nvml_dev # nvml.h
      cuda_nvtx.dev # nvToolsExt.h
      libcublas.dev # cublas_api.h
      libcufft.dev # cufft.h
      libcurand.dev # curand.h
      libcusolver.dev # cusolver_common.h
      libcusparse.dev # cusparse.h
    ];
  };

  backend_cc_joined = symlinkJoin {
    name = "cuda-cc-joined";
    paths = [
      effectiveStdenv.cc
      binutils.bintools # for ar, dwp, nm, objcopy, objdump, strip
    ];
  };

  # Copy-paste from TF derivation.
  # Most of these are not really used in jaxlib compilation but it's simpler to keep it
  # 'as is' so that it's more compatible with TF derivation.
  tf_system_libs = [
    "absl_py"
    "astor_archive"
    "astunparse_archive"
    # Not packaged in nixpkgs
    # "com_github_googleapis_googleapis"
    # "com_github_googlecloudplatform_google_cloud_cpp"
    # Issue with transitive dependencies after https://github.com/grpc/grpc/commit/f1d14f7f0b661bd200b7f269ef55dec870e7c108
    # "com_github_grpc_grpc"
    # ERROR: /build/output/external/bazel_tools/tools/proto/BUILD:25:6: no such target '@com_google_protobuf//:cc_toolchain':
    # target 'cc_toolchain' not declared in package '' defined by /build/output/external/com_google_protobuf/BUILD.bazel
    # "com_google_protobuf"
    # Fails with the error: external/org_tensorflow/tensorflow/core/profiler/utils/tf_op_utils.cc:46:49: error: no matching function for call to 're2::RE2::FullMatch(absl::lts_2020_02_25::string_view&, re2::RE2&)'
    # "com_googlesource_code_re2"
    "curl"
    "cython"
    "dill_archive"
    "double_conversion"
    "flatbuffers"
    "functools32_archive"
    "gast_archive"
    "gif"
    "hwloc"
    "icu"
    "jsoncpp_git"
    "libjpeg_turbo"
    "lmdb"
    "nasm"
    "opt_einsum_archive"
    "org_sqlite"
    "pasta"
    "png"
    # ERROR: /build/output/external/pybind11/BUILD.bazel: no such target '@pybind11//:osx':
    # target 'osx' not declared in package '' defined by /build/output/external/pybind11/BUILD.bazel
    # "pybind11"
    "six_archive"
    "snappy"
    "tblib_archive"
    "termcolor_archive"
    "typing_extensions_archive"
    "wrapt"
    "zlib"
  ];

  arch =
    # KeyError: ('Linux', 'arm64')
    if effectiveStdenv.hostPlatform.isLinux && effectiveStdenv.hostPlatform.linuxArch == "arm64" then "aarch64"
    else effectiveStdenv.hostPlatform.linuxArch;

  xla = effectiveStdenv.mkDerivation {
    pname = "xla-src";
    version = "unstable";

    src = fetchFromGitHub {
      owner = "openxla";
      repo = "xla";
      # Update this according to https://github.com/google/jax/blob/jaxlib-v${version}/third_party/xla/workspace.bzl.
      rev = "12eee889e1f2ad41e27d7b0e970cb92d282d3ec5";
      hash = "sha256-68kjjgwYjRlcT0TVJo9BN6s+WTkdu5UMJqQcfHpBT90=";
    };

    patches = [
      # Resolves "could not convert ‘result’ from ‘SmallVector<[...],6>’ to
      # ‘SmallVector<[...],4>’" compilation error. See https://github.com/google/jax/issues/19814#issuecomment-1945141259.
      (fetchpatch {
        url = "https://github.com/openxla/xla/commit/7a614cd346594fc7ea2fe75570c9c53a4a444f60.patch";
        hash = "sha256-RtuQTH8wzNiJcOtISLhf+gMlH1gg8hekvxEB+4wX6BM=";
      })
    ];

    dontBuild = true;

    # This is necessary for patchShebangs to know the right path to use.
    nativeBuildInputs = [ python ];

    # Main culprits we're targeting are third_party/tsl/third_party/gpus/crosstool/clang/bin/*.tpl
    postPatch = ''
      patchShebangs .
    '';

    installPhase = ''
      cp -r . $out
    '';
  };

  bazel-build = buildBazelPackage rec {
    name = "bazel-build-${pname}-${version}";

    # See https://github.com/google/jax/blob/main/.bazelversion for the latest.
    bazel = bazel_6;

    src = fetchFromGitHub {
      owner = "google";
      repo = "jax";
      # google/jax contains tags for jax and jaxlib. Only use jaxlib tags!
      rev = "refs/tags/${pname}-v${version}";
      hash = "sha256-hmx7eo3pephc6BQfoJ3U0QwWBWmhkAc+7S4QmW32qQs=";
    };

    nativeBuildInputs = [
      cython
      pkgs.flatbuffers
      git
      setuptools
      wheel
      build
      which
    ] ++ lib.optionals effectiveStdenv.isDarwin [
      cctools
    ];

    buildInputs = [
      curl
      double-conversion
      giflib
      jsoncpp
      libjpeg_turbo
      numpy
      openssl
      pkgs.flatbuffers
      pkgs.protobuf
      pybind11
      scipy
      six
      snappy
      zlib
    ] ++ lib.optionals effectiveStdenv.isDarwin [
      IOKit
    ] ++ lib.optionals (!effectiveStdenv.isDarwin) [
      nsync
    ];

    # We don't want to be quite so picky regarding bazel version
    postPatch = ''
      rm -f .bazelversion
    '';

    bazelRunTarget = "//jaxlib/tools:build_wheel";
    runTargetFlags = [
      "--output_path=$out"
      "--cpu=${arch}"
      # This has no impact whatsoever...
      "--jaxlib_git_hash='12345678'"
    ];

    removeRulesCC = false;

    GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${backend_cc_joined}/bin";
    GCC_HOST_COMPILER_PATH = lib.optionalString cudaSupport "${backend_cc_joined}/bin/gcc";

    # The version is automatically set to ".dev" if this variable is not set.
    # https://github.com/google/jax/commit/e01f2617b85c5bdffc5ffb60b3d8d8ca9519a1f3
    JAXLIB_RELEASE = "1";

    preConfigure =
      # Dummy ldconfig to work around "Can't open cache file /nix/store/<hash>-glibc-2.38-44/etc/ld.so.cache" error
      ''
        mkdir dummy-ldconfig
        echo "#!${effectiveStdenv.shell}" > dummy-ldconfig/ldconfig
        chmod +x dummy-ldconfig/ldconfig
        export PATH="$PWD/dummy-ldconfig:$PATH"
      '' +

      # Construct .jax_configure.bazelrc. See https://github.com/google/jax/blob/b9824d7de3cb30f1df738cc42e486db3e9d915ff/build/build.py#L259-L345
      # for more info. We assume
      # * `cpu = None`
      # * `enable_nccl = True`
      # * `target_cpu_features = "release"`
      # * `rocm_amdgpu_targets = None`
      # * `enable_rocm = False`
      # * `build_gpu_plugin = False`
      # * `use_clang = False` (Should we use `effectiveStdenv.cc.isClang` instead?)
      #
      # Note: We should try just running https://github.com/google/jax/blob/ceb198582b62b9e6f6bdf20ab74839b0cf1db16e/build/build.py#L259-L266
      # instead of duplicating the logic here. Perhaps we can leverage the
      # `--configure_only` flag (https://github.com/google/jax/blob/ceb198582b62b9e6f6bdf20ab74839b0cf1db16e/build/build.py#L544-L548)?
      ''
        cat <<CFG > ./.jax_configure.bazelrc
        build --strategy=Genrule=standalone
        build --repo_env PYTHON_BIN_PATH="${python}/bin/python"
        build --action_env=PYENV_ROOT
        build --python_path="${python}/bin/python"
        build --distinct_host_configuration=false
        build --define PROTOBUF_INCLUDE_PATH="${pkgs.protobuf}/include"
      '' + lib.optionalString cudaSupport ''
        build --config=cuda
        build --action_env CUDA_TOOLKIT_PATH="${cuda_build_deps_joined}"
        build --action_env CUDNN_INSTALL_PATH="${cudnn}"
        build --action_env TF_CUDA_PATHS="${cuda_build_deps_joined},${cudnn},${nccl}"
        build --action_env TF_CUDA_VERSION="${lib.versions.majorMinor cudaVersion}"
        build --action_env TF_CUDNN_VERSION="${lib.versions.major cudnn.version}"
        build:cuda --action_env TF_CUDA_COMPUTE_CAPABILITIES="${builtins.concatStringsSep "," cudaFlags.realArches}"
      '' +
      # Note that upstream conditions this on `wheel_cpu == "x86_64"`. We just
      # rely on `effectiveStdenv.hostPlatform.avxSupport` instead. So far so
      # good. See https://github.com/google/jax/blob/b9824d7de3cb30f1df738cc42e486db3e9d915ff/build/build.py#L322
      # for upstream's version.
      lib.optionalString (effectiveStdenv.hostPlatform.avxSupport && effectiveStdenv.hostPlatform.isUnix) ''
        build --config=avx_posix
      '' + lib.optionalString mklSupport ''
        build --config=mkl_open_source_only
      '' +
      ''
        CFG
      '';

    # Make sure Bazel knows about our configuration flags during fetching so that the
    # relevant dependencies can be downloaded.
    bazelFlags = [
      "-c opt"
      # See https://bazel.build/external/advanced#overriding-repositories for
      # information on --override_repository flag.
      "--override_repository=xla=${xla}"
    ] ++ lib.optionals effectiveStdenv.cc.isClang [
      # bazel depends on the compiler frontend automatically selecting these flags based on file
      # extension but our clang doesn't.
      # https://github.com/NixOS/nixpkgs/issues/150655
      "--cxxopt=-x"
      "--cxxopt=c++"
      "--host_cxxopt=-x"
      "--host_cxxopt=c++"
    ];

    # We intentionally overfetch so we can share the fetch derivation across all the different configurations
    fetchAttrs = {
      TF_SYSTEM_LIBS = lib.concatStringsSep "," tf_system_libs;
      # we have to force @mkl_dnn_v1 since it's not needed on darwin
      bazelTargets = [ bazelRunTarget "@mkl_dnn_v1//:mkl_dnn" ];
      bazelFlags = bazelFlags ++ [
        "--config=avx_posix"
        "--config=mkl_open_source_only"
      ] ++ lib.optionals cudaSupport [
        # ideally we'd add this unconditionally too, but it doesn't work on darwin
        # we make this conditional on `cudaSupport` instead of the system, so that the hash for both
        # the cuda and the non-cuda deps can be computed on linux, since a lot of contributors don't
        # have access to darwin machines
        "--config=cuda"
      ];

      sha256 = (if cudaSupport then {
        x86_64-linux = "sha256-8JilAoTbqOjOOJa/Zc/n/quaEDcpdcLXCNb34mfB+OM=";
      } else {
        x86_64-linux = "sha256-iqS+I1FQLNWXNMsA20cJp7YkyGUeshee5b2QfRBNZtk=";
        aarch64-linux = "sha256-qmJ0Fm/VGMTmko4PhKs1P8/GLEJmVxb8xg+ss/HsakY==";
      }).${effectiveStdenv.system} or (throw "jaxlib: unsupported system: ${effectiveStdenv.system}");
    };

    buildAttrs = {
      outputs = [ "out" ];

      TF_SYSTEM_LIBS = lib.concatStringsSep "," (tf_system_libs ++ lib.optionals (!effectiveStdenv.isDarwin) [
        "nsync" # fails to build on darwin
      ]);

      # Note: we cannot do most of this patching at `patch` phase as the deps
      # are not available yet. Framework search paths aren't added by bintools
      # hook. See https://github.com/NixOS/nixpkgs/pull/41914.
      preBuild = lib.optionalString effectiveStdenv.isDarwin ''
        export NIX_LDFLAGS+=" -F${IOKit}/Library/Frameworks"
        substituteInPlace ../output/external/rules_cc/cc/private/toolchain/osx_cc_wrapper.sh.tpl \
          --replace "/usr/bin/install_name_tool" "${cctools}/bin/install_name_tool"
        substituteInPlace ../output/external/rules_cc/cc/private/toolchain/unix_cc_configure.bzl \
          --replace "/usr/bin/libtool" "${cctools}/bin/libtool"
      '';
    };

    inherit meta;
  };
  platformTag =
    if effectiveStdenv.hostPlatform.isLinux then
      "manylinux2014_${arch}"
    else if effectiveStdenv.system == "x86_64-darwin" then
      "macosx_10_9_${arch}"
    else if effectiveStdenv.system == "aarch64-darwin" then
      "macosx_11_0_${arch}"
    else throw "Unsupported target platform: ${effectiveStdenv.hostPlatform}";

in
buildPythonPackage {
  inherit meta pname version;
  format = "wheel";

  src =
    let cp = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
    in "${bazel-build}/jaxlib-${version}-${cp}-${cp}-${platformTag}.whl";

  # Note that jaxlib looks for "ptxas" in $PATH. See https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621
  # for more info.
  postInstall = lib.optionalString cudaSupport ''
    mkdir -p $out/bin
    ln -s ${cudaPackagesGoogle.cuda_nvcc.bin}/bin/ptxas $out/bin/ptxas

    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      patchelf --add-rpath "${lib.makeLibraryPath [cuda_libs_joined cudnn nccl]}" "$lib"
    done
  '';

  nativeBuildInputs = lib.optionals cudaSupport [ autoAddDriverRunpath ];

  propagatedBuildInputs = [
    absl-py
    curl
    double-conversion
    flatbuffers
    giflib
    jsoncpp
    libjpeg_turbo
    ml-dtypes
    numpy
    scipy
    six
    snappy
  ];

  pythonImportsCheck = [
    "jaxlib"
    # `import jaxlib` loads surprisingly little. These imports are actually bugs that appeared in the 0.4.11 upgrade.
    "jaxlib.cpu_feature_guard"
    "jaxlib.xla_client"
  ];

  # Without it there are complaints about libcudart.so.11.0 not being found
  # because RPATH path entries added above are stripped.
  dontPatchELF = cudaSupport;
}
