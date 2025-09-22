{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  versionCheckHook,
  setuptools,

  # dependencies
  onnxruntime,
  onnx,
  rich,
}:

buildPythonPackage rec {
  pname = "onnxsim";
  version = "0.4.36";
  pyproject = true;

  src = fetchPypi {
    pname = "onnxsim";
    inherit version;
    sha256 = "sha256-bg7p1tSoMEK973MZ++WDUtn9pfJTOGvismfHwn8GOO4=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    onnx
    onnxruntime
    rich
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires.append('pytest-runner')" ""
  '';

  pythonImportsCheck = [ "onnxsim" ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "-v";

  meta = {
    description = "Simplify your ONNX model";
    homepage = "https://github.com/daquexian/onnx-simplifier";
    license = lib.licenses.asl20;
    mainProgram = "onnxsim";
    maintainers = with lib.maintainers; [
      osbm
      acairncross
    ];
  };
}
