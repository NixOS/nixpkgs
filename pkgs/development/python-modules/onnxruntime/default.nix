{
  lib,
  stdenv,
  buildPythonPackage,
  onnxruntime,
  autoPatchelfHook,

  # buildInputs
  onednn,
  re2,

  # dependencies
  coloredlogs,
  numpy,
  packaging,
}:

# onnxruntime requires an older protobuf.
# Doing an override in protobuf in the python-packages set
# can give you a functioning Python package but note not
# all Python packages will be compatible then.
#
# Because protobuf is not always needed we remove it
# as a runtime dependency from our wheel.
#
# We do include here the non-Python protobuf so the shared libs
# link correctly. If you do also want to include the Python
# protobuf, you can add it to your Python env, but be aware
# the version likely mismatches with what is used here.

buildPythonPackage {
  inherit (onnxruntime) pname version;
  format = "wheel";
  src = onnxruntime.dist;

  unpackPhase = ''
    cp -r $src dist
    chmod +w dist
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_LDFLAGS = "-z,noexecstack";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # This project requires fairly large dependencies such as sympy which we really don't always need.
  pythonRemoveDeps = [
    "flatbuffers"
    "protobuf"
    "sympy"
  ];

  # Libraries are not linked correctly.
  buildInputs = [
    onednn
    re2
    onnxruntime.protobuf

    # https://github.com/NixOS/nixpkgs/pull/357656 patches the onnx lib to ${pkgs.onnxruntime}/lib
    # but these files are copied into this package too. If the original non-python onnxruntime
    # package is GC-ed, cuda support in this python package will break.
    # Two options, rebuild onnxruntime twice with the different paths hard-coded, or just hold a runtime
    # dependency between the two. Option 2, because onnxruntime takes forever to build with cuda support.
    onnxruntime
  ]
  ++ lib.optionals onnxruntime.passthru.cudaSupport (
    with onnxruntime.passthru.cudaPackages;
    [
      libcublas # libcublasLt.so.XX libcublas.so.XX
      libcurand # libcurand.so.XX
      libcufft # libcufft.so.XX
      cudnn # libcudnn.soXX
      cuda_cudart # libcudart.so.XX
    ]
    ++ lib.optionals onnxruntime.passthru.ncclSupport [
      nccl # libnccl.so.XX
    ]
  );

  dependencies = [
    coloredlogs
    numpy
    packaging
  ];

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  #
  # While this problem has existed for a while, it started occuring at import time since the update
  # of onnxruntime to 1.23.1 (https://github.com/NixOS/nixpkgs/pull/450587)
  pythonImportsCheck =
    lib.optionals (!(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64))
      [
        "onnxruntime"
      ];

  meta = onnxruntime.meta;
}
