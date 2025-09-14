{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  numpy,
  pybind11,
  setuptools,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "qdldl";
  version = "0.1.7.post5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osqp";
    repo = "qdldl-python";
    tag = "v${version}";
    hash = "sha256-XHdvYWORHDYy/EIqmlmFQZwv+vK3I+rPIrvcEW1JyIw=";
  };

  dontUseCmakeConfigure = true;

  build-system = [
    cmake
    numpy
    pybind11
    setuptools
  ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "qdldl" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Free LDL factorization routine";
    homepage = "https://github.com/oxfordcontrol/qdldl";
    downloadPage = "https://github.com/oxfordcontrol/qdldl-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
