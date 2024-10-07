{ lib
, stdenv
, buildPythonPackage
, autoPatchelfHook
, pythonRelaxDepsHook
, onnxruntime-genai
, coloredlogs
, numpy
, packaging
, oneDNN
, re2

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
  inherit (onnxruntime-genai) pname version;
  format = "wheel";
  src = onnxruntime-genai.dist;

  unpackPhase = ''
    cp -r $src dist
    chmod +w dist
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

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
    onnxruntime-genai.protobuf
    onnxruntime-genai.onnxruntime
    onnxruntime-genai.onnxruntime-extensions
  ] ++ lib.optionals onnxruntime-genai.passthru.cudaSupport (with onnxruntime-genai.passthru.cudaPackages; [
    libcublas # libcublasLt.so.XX libcublas.so.XX
    libcurand # libcurand.so.XX
    libcufft # libcufft.so.XX
    cudnn # libcudnn.soXX
    cuda_cudart # libcudart.so.XX
  ]);

  propagatedBuildInputs = [
    coloredlogs
    # flatbuffers
    numpy
    packaging
    # protobuf
    # sympy
  ];

  meta = onnxruntime-genai.meta;
}
