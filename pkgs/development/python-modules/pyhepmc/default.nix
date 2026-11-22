{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  setuptools-scm,
  backports-zstd,
  numpy,
  pybind11,
  wheel,
  pytestCheckHook,
  graphviz,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhepmc";
  version = "2.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "pyhepmc";
    tag = finalAttrs.version;
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

  dependencies = [
    backports-zstd
    numpy
  ];

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
    changelog = "https://github.com/scikit-hep/pyhepmc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
