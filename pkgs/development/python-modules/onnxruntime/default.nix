{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, autoPatchelfHook
, pythonRelaxDepsHook
, onnxruntime
, coloredlogs
, numpy
, packaging
, oneDNN
<<<<<<< HEAD
, re2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

  nativeBuildInputs = [
<<<<<<< HEAD
    pythonRelaxDepsHook
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
=======
    autoPatchelfHook
    pythonRelaxDepsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    re2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    onnxruntime.protobuf
  ];

  propagatedBuildInputs = [
    coloredlogs
    # flatbuffers
    numpy
    packaging
    # protobuf
    # sympy
  ];

  meta = onnxruntime.meta // { maintainers = with lib.maintainers; [ fridh ]; };
}
