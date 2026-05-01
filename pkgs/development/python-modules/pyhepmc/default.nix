{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  setuptools-scm,
  numpy,
  pybind11,
  wheel,
  pytestCheckHook,
  graphviz,
}:

buildPythonPackage rec {
  pname = "pyhepmc";
  version = "2.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "pyhepmc";
    tag = version;
    hash = "sha256-FMxcebZikZXwgEW3BIlHtDVQPweN8zBku0K8FOmF6vA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [ pybind11 ];

  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  env.CMAKE_ARGS = toString [ "-DEXTERNAL_PYBIND11=ON" ];

  nativeCheckInputs = [
    graphviz
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyhepmc" ];

  meta = {
    description = "Easy-to-use Python bindings for HepMC3";
    homepage = "https://github.com/scikit-hep/pyhepmc";
    changelog = "https://github.com/scikit-hep/pyhepmc/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
