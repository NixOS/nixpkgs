{ stdenv
, fetchurl, python3, which
, patchelf, fetchFromGitHub, buildBazelPackage
, cudatoolkit, cudnn, nccl, nvidia_x11, symlinkJoin
, binutils, gcc, binutils-unwrapped, gcc-unwrapped
, glibcLocales
, features ? ["sse4.2" "avx" "avx2" "fma"]
, arch ? "x86-64"
, cudaSupport ? false
, computeCapabilities ? [] # example: [ "7.5" ], see https://developer.nvidia.com/cuda-gpus
}:
let
  inherit (stdenv) lib;
  cudatoolkit_joined = symlinkJoin {
    name = "unsplit_cudatoolkit";
    paths = [ cudatoolkit.out
              cudatoolkit.lib ];};
  gcc_joined = symlinkJoin {
    name = "gcc-joined";
    paths = [ binutils gcc binutils-unwrapped gcc-unwrapped ];
  };
in
buildBazelPackage rec {
  pname = "tensorflow";
  version = "1.14.0";
  name = "${pname}-${version}";
  bazelFlags = [ "--incompatible_no_support_tools_in_action_inputs=false" ];
  bazelTarget = "//tensorflow/tools/lib_package:libtensorflow";
  fetchAttrs = {
    sha256 = if cudaSupport then
      "127xxwy3a2h1qsv2sqfhrh65g69hlb1q003vyyg7yjfqgfah9p2z"
      else "1di1pnknr1hxdpn75lxf9c6dvb5kgllmgb9r9rgh5c2g9iil17zy";
  };
  CC_OPT_FLAGS = "-march=${arch} " + stdenv.lib.concatMapStringsSep " " (f: "-m"+f) features;
  NIX_CFLAGS_COMPILE = CC_OPT_FLAGS;
  TF_NEED_CUDA = if cudaSupport then "1" else "0";
  TF_IGNORE_MAX_BAZEL_VERSION = "1";
  TF_CUDA_COMPUTE_CAPABILITIES = stdenv.lib.concatStringsSep "," computeCapabilities;
  nativeBuildInputs = [ glibcLocales python3 which ]
    ++ (lib.optionals cudaSupport [
    cudatoolkit_joined cudnn nvidia_x11
  ]);
  TF_CUDA_PATHS = lib.optionalString cudaSupport "${cudatoolkit_joined},${cudnn}";
  src = fetchFromGitHub {
    repo = "tensorflow";
    owner = "tensorflow";
    rev = "v${version}";
    sha256 = "06jvwlsm14b8rqwd8q8796r0vmn0wk64s4ps2zg0sapkmp9vvcmi";
  };
  prePatch = ''
    # doesn't work:
    sed -i '/saved_model_portable_proto/d' tensorflow/cc/saved_model/BUILD
    # calls ldconfig -p:
    sed -i 's/+ _get_ld_config_paths()//' third_party/gpus/find_cuda_config.py
    patchShebangs ./configure
    patchShebangs tensorflow/tools/lib_package/concat_licenses.sh
    patchShebangs third_party/gpus/crosstool/clang/bin/crosstool_wrapper_driver_is_not_gcc.tpl
  '';
  GCC_HOST_COMPILER_PREFIX = lib.optionalString cudaSupport "${gcc_joined}/bin";
  configurePhase = ''
    runHook preConfigure
    ./configure
    runHook postConfigure
  '';
  buildAttrs = {
    installPhase = ''
      mkdir -p $out
      tar -xf bazel-bin/tensorflow/tools/lib_package/libtensorflow.tar.gz -C $out
      # Write pkgconfig file.
      mkdir $out/lib/pkgconfig
      cat > $out/lib/pkgconfig/tensorflow.pc << EOF
      Name: TensorFlow
      Version: ${version}
      Description: Library for computation using data flow graphs for scalable machine learning
      Requires:
      Libs: -L$out/lib -ltensorflow
      Cflags: -I$out/include/tensorflow
      EOF
    '';
  };
  meta = with lib; {
    description = "C API for TensorFlow";
    homepage = https://www.tensorflow.org/versions/master/install/install_c;
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ basvandijk yorickvp ];
  };
}
