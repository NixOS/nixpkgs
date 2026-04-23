{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  cmake,
  numpy,
  pybind11,
  setuptools,
  scipy,
  pytestCheckHook,
  qdldl,
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

  # use up-to-date qdldl for CMake v4
  patches = [
    (replaceVars ./use-qdldl.patch {
      inherit qdldl;
    })
  ];

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

  propagatedBuildInputs = [
    qdldl
  ];

  pythonImportsCheck = [ "qdldl" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python interface to the QDLDL";
    homepage = "https://github.com/osqp/qdldl-python";
    changelog = "https://github.com/osqp/qdldl-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
