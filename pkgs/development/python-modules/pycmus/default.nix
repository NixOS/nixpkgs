{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pycmus";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wk9J/XjKZB13o8QmdByVWHcAdfNOicwLaH2Sh4qJcIw=";
  };

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    six
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "pycmus"
  ];

  meta = {
    description = "Python library for sending commands to the cmus music player";
    homepage = "https://github.com/mtreinish/pycmus";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
