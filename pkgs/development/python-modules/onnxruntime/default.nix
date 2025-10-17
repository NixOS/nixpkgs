{
  lib,
  stdenv,
  buildPythonPackage,
  onnxruntime,
  autoPatchelfHook,

  # buildInputs
  oneDNN,
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # This project requires fairly large dependencies such as sympy which we really don't always need.
  pythonRemoveDeps = [
    "flatbuffers"
    "protobuf"
    "sympy"
  ];

  # Libraries are not linked correctly.
  buildInputs = [
    oneDNN
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
      nccl # libnccl.so.XX
    ]
  );

  dependencies = [
    coloredlogs
    numpy
    packaging
  ];

  meta = onnxruntime.meta;
}
