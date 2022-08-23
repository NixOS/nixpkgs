{ lib
, pkgs
, stdenv

  # Build-time dependencies:
, addOpenGLRunpath
, bazel_5
, binutils
, buildBazelPackage
, buildPythonPackage
, cctools
, cython
, fetchFromGitHub
, git
, IOKit
, jsoncpp
, pybind11
, setuptools
, symlinkJoin
, wheel
, which

  # Python dependencies:
, absl-py
, flatbuffers
, numpy
, scipy
, six

  # Runtime dependencies:
, double-conversion
, giflib
, grpc
, libjpeg_turbo
, python
, snappy
, zlib

  # CUDA flags:
, cudaCapabilities ? [ "sm_35" "sm_50" "sm_60" "sm_70" "sm_75" "compute_80" ]
, cudaSupport ? false
, cudaPackages ? {}

  # MKL:
, mklSupport ? true
}:

let

  inherit (cudaPackages) cudatoolkit cudnn nccl;

  pname = "jaxlib";
  version = "0.3.0";

  meta = with lib; {
    description = "JAX is Autograd and XLA, brought together for high-performance machine learning research.";
    homepage = "https://github.com/google/jax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
    platforms = platforms.unix;
    # aarch64-darwin is broken because of https://github.com/bazelbuild/rules_cc/pull/136
    # however even with that fix applied, it doesn't work for everyone:
    # https://github.com/NixOS/nixpkgs/pull/184395#issuecomment-1207287129
    broken = stdenv.isAarch64;
  };

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-merged";
    paths = [
      cudatoolkit.lib
      cudatoolkit.out
    ] ++ lib.optionals (lib.versionOlder cudatoolkit.version "11") [
      # for some reason some of the required libs are in the targets/x86_64-linux
      # directory; not sure why but this works around it
      "${cudatoolkit}/targets/${stdenv.system}"
    ];
  };

  cudatoolkit_cc_joined = symlinkJoin {
    name = "${cudatoolkit.cc.name}-merged";
    paths = [
      cudatoolkit.cc
      binutils.bintools # for ar, dwp, nm, objcopy, objdump, strip
    ];
  };

  bazel-build = buildBazelPackage {
    name = "bazel-build-${pname}-${version}";

    bazel = bazel_5;

    src = fetchFromGitHub {
      owner = "google";
      repo = "jax";
      rev = "${pname}-v${version}";
      sha256 = "0ndpngx5k6lf6jqjck82bbp0gs943z0wh7vs9gwbyk2bw0da7w72";
    };

    nativeBuildInputs = [
      cython
      pkgs.flatbuffers
      git
      setuptools
      wheel
      which
    ];

    buildInputs = [
      double-conversion
      giflib
      grpc
      jsoncpp
      libjpeg_turbo
      numpy
      pkgs.flatbuffers
      pkgs.protobuf
      pybind11
      scipy
      six
      snappy
      zlib
    ] ++ lib.optionals cudaSupport [
      cudatoolkit
      cudnn
    ] ++ lib.optionals stdenv.isDarwin [
      IOKit
    ];

    postPatch = ''
      rm -f .bazelversion
    '';

    bazelTarget = "//build:build_wheel";

    removeRulesCC = false;

    GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin";
    GCC_HOST_COMPILER_PATH = lib.optionalString cudaSupport "${cudatoolkit_cc_joined}/bin/gcc";

    preConfigure = ''
      # dummy ldconfig
      mkdir dummy-ldconfig
      echo "#!${stdenv.shell}" > dummy-ldconfig/ldconfig
      chmod +x dummy-ldconfig/ldconfig
      export PATH="$PWD/dummy-ldconfig:$PATH"
      cat <<CFG > ./.jax_configure.bazelrc
      build --strategy=Genrule=standalone
      build --repo_env PYTHON_BIN_PATH="${python}/bin/python"
      build --action_env=PYENV_ROOT
      build --python_path="${python}/bin/python"
      build --distinct_host_configuration=false
    '' + lib.optionalString cudaSupport ''
      build --action_env CUDA_TOOLKIT_PATH="${cudatoolkit_joined}"
      build --action_env CUDNN_INSTALL_PATH="${cudnn}"
      build --action_env TF_CUDA_PATHS="${cudatoolkit_joined},${cudnn},${nccl}"
      build --action_env TF_CUDA_VERSION="${lib.versions.majorMinor cudatoolkit.version}"
      build --action_env TF_CUDNN_VERSION="${lib.versions.major cudnn.version}"
      build:cuda --action_env TF_CUDA_COMPUTE_CAPABILITIES="${lib.concatStringsSep "," cudaCapabilities}"
    '' + ''
      CFG
    '';

    # Copy-paste from TF derivation.
    # Most of these are not really used in jaxlib compilation but it's simpler to keep it
    # 'as is' so that it's more compatible with TF derivation.
    TF_SYSTEM_LIBS = lib.concatStringsSep "," [
      "absl_py"
      "astor_archive"
      "astunparse_archive"
      "boringssl"
      # Not packaged in nixpkgs
      # "com_github_googleapis_googleapis"
      # "com_github_googlecloudplatform_google_cloud_cpp"
      "com_github_grpc_grpc"
      "com_google_protobuf"
      # Fails with the error: external/org_tensorflow/tensorflow/core/profiler/utils/tf_op_utils.cc:46:49: error: no matching function for call to 're2::RE2::FullMatch(absl::lts_2020_02_25::string_view&, re2::RE2&)'
      # "com_googlesource_code_re2"
      "curl"
      "cython"
      "dill_archive"
      "double_conversion"
      "enum34_archive"
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
      # "nsync" # not packaged in nixpkgs
      "opt_einsum_archive"
      "org_sqlite"
      "pasta"
      "pcre"
      "png"
      "pybind11"
      "six_archive"
      "snappy"
      "tblib_archive"
      "termcolor_archive"
      "typing_extensions_archive"
      "wrapt"
      "zlib"
    ];

    # Make sure Bazel knows about our configuration flags during fetching so that the
    # relevant dependencies can be downloaded.
    bazelFlags = [
      "-c opt"
    ] ++ lib.optional (stdenv.targetPlatform.isx86_64 && stdenv.targetPlatform.isUnix) [
      "--config=avx_posix"
    ] ++ lib.optional cudaSupport [
      "--config=cuda"
    ] ++ lib.optional mklSupport [
      "--config=mkl_open_source_only"
    ] ++ lib.optionals stdenv.cc.isClang [
      # bazel depends on the compiler frontend automatically selecting these flags based on file
      # extension but our clang doesn't.
      # https://github.com/NixOS/nixpkgs/issues/150655
      "--cxxopt=-x" "--cxxopt=c++" "--host_cxxopt=-x" "--host_cxxopt=c++"
    ];

    fetchAttrs = {
      sha256 =
        if cudaSupport then
          "sha256-Ald+vplRx/DDG/7TfHAqD4Gktb1BGnf7FSCCJzSI0eo="
        else
          "sha256-eK5IjTAncDarkWYKnXrEo7kw7J7iOH7in2L2GabnFYo=";
    };

    buildAttrs = {
      outputs = [ "out" ];

      # Note: we cannot do most of this patching at `patch` phase as the deps are not available yet.
      # 1) Fix pybind11 include paths.
      # 2) Link protobuf from nixpkgs (through TF_SYSTEM_LIBS when using gcc) to prevent crashes on
      #    loading multiple extensions in the same python program due to duplicate protobuf DBs.
      # 3) Patch python path in the compiler driver.
      # 4) Patch tensorflow sources to work with later versions of protobuf. See
      #    https://github.com/google/jax/issues/9534. Note that this should be
      #    removed on the next release after 0.3.0.
      preBuild = ''
        for src in ./jaxlib/*.{cc,h}; do
          sed -i 's@include/pybind11@pybind11@g' $src
        done
        substituteInPlace ../output/external/org_tensorflow/tensorflow/compiler/xla/python/pprof_profile_builder.cc \
          --replace "status.message()" "std::string{status.message()}"
      '' + lib.optionalString cudaSupport ''
        patchShebangs ../output/external/org_tensorflow/third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc.tpl
      '' + lib.optionalString stdenv.isDarwin ''
        # Framework search paths aren't added by bintools hook
        # https://github.com/NixOS/nixpkgs/pull/41914
        export NIX_LDFLAGS+=" -F${IOKit}/Library/Frameworks"
        substituteInPlace ../output/external/rules_cc/cc/private/toolchain/osx_cc_wrapper.sh.tpl \
          --replace "/usr/bin/install_name_tool" "${cctools}/bin/install_name_tool"
        substituteInPlace ../output/external/rules_cc/cc/private/toolchain/unix_cc_configure.bzl \
          --replace "/usr/bin/libtool" "${cctools}/bin/libtool"
      '' + (if stdenv.cc.isGNU then ''
        sed -i 's@-lprotobuf@-l:libprotobuf.a@' ../output/external/org_tensorflow/third_party/systemlibs/protobuf.BUILD
        sed -i 's@-lprotoc@-l:libprotoc.a@' ../output/external/org_tensorflow/third_party/systemlibs/protobuf.BUILD
      '' else if stdenv.cc.isClang then ''
        sed -i 's@-lprotobuf@${pkgs.protobuf}/lib/libprotobuf.a@' ../output/external/org_tensorflow/third_party/systemlibs/protobuf.BUILD
        sed -i 's@-lprotoc@${pkgs.protobuf}/lib/libprotoc.a@' ../output/external/org_tensorflow/third_party/systemlibs/protobuf.BUILD
      '' else throw "Unsupported stdenv.cc: ${stdenv.cc}");

      installPhase = ''
        ./bazel-bin/build/build_wheel --output_path=$out --cpu=${stdenv.targetPlatform.linuxArch}
      '';
    };

    inherit meta;
  };
  platformTag =
    if stdenv.targetPlatform.isLinux then
      "manylinux2010_${stdenv.targetPlatform.linuxArch}"
    else if stdenv.system == "x86_64-darwin" then
      "macosx_10_9_${stdenv.targetPlatform.linuxArch}"
    else if stdenv.system == "aarch64-darwin" then
      "macosx_11_0_${stdenv.targetPlatform.linuxArch}"
    else throw "Unsupported target platform: ${stdenv.targetPlatform}";

in
buildPythonPackage {
  inherit meta pname version;
  format = "wheel";

  src = "${bazel-build}/jaxlib-${version}-cp${builtins.replaceStrings ["."] [""] python.pythonVersion}-none-${platformTag}.whl";

  # Note that cudatoolkit is necessary since jaxlib looks for "ptxas" in $PATH.
  # See https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621 for
  # more info.
  postInstall = lib.optionalString cudaSupport ''
    mkdir -p $out/bin
    ln -s ${cudatoolkit}/bin/ptxas $out/bin/ptxas

    find $out -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      addOpenGLRunpath "$lib"
      patchelf --set-rpath "${cudatoolkit}/lib:${cudatoolkit.lib}/lib:${cudnn}/lib:${nccl}/lib:$(patchelf --print-rpath "$lib")" "$lib"
    done
  '';

  nativeBuildInputs = lib.optional cudaSupport addOpenGLRunpath;

  propagatedBuildInputs = [
    absl-py
    double-conversion
    flatbuffers
    giflib
    grpc
    jsoncpp
    libjpeg_turbo
    numpy
    scipy
    six
    snappy
  ];

  pythonImportsCheck = [ "jaxlib" ];

  # Without it there are complaints about libcudart.so.11.0 not being found
  # because RPATH path entries added above are stripped.
  dontPatchELF = cudaSupport;
}
