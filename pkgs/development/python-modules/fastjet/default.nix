{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  pybind11,
  scikit-build-core,
  setuptools-scm,

  # nativeBuildInputs
  swig,

  # dependencies
  awkward,
  numpy,
  vector,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastjet";
  version = "3.5.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scikit-hep";
    repo = "fastjet";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-uR7HK00s3uuojJ2x5LmNhvJHJ+umCOua4SUXafH0NEk=";
  };

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
    setuptools-scm
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    swig
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies = [
    awkward
    numpy
    vector
  ];

  pythonImportsCheck = [ "fastjet" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Jet-finding in the Scikit-HEP ecosystem";
    homepage = "https://github.com/scikit-hep/fastjet";
    changelog = "https://github.com/scikit-hep/fastjet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
