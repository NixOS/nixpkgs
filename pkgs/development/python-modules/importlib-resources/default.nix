{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  importlib-metadata,

  # Reverse dependency
  sage,

  # tests
  jaraco-collections,
  jaraco-test,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "7.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    hash = "sha256-ByLUxiEkicUw8qFFo0wKejtHIbyWoV+tpZMOKgt2Bwg=";
  };

  postPatch = ''
    sed -i '/coherent.licensed/d' pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ importlib-metadata ];

  nativeCheckInputs = [
    pytestCheckHook
    jaraco-collections
    jaraco-test
  ];

  pythonImportsCheck = [ "importlib_resources" ];

  passthru.tests = {
    inherit sage;
  };

  meta = {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
