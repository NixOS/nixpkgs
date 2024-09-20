{
  lib,
  buildPythonPackage,
  docopt,
  fetchPypi,
  pytz,
  setuptools,
  setuptools-scm,
  six,
  sqlalchemy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygtfs";
  version = "0.1.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J5vu51OOMabWd8h60PpvvBiCnwQlhEnBywNXxy9hOuA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    docopt
    pytz
    six
    sqlalchemy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "pygtfs/test/test.py" ];

  pythonImportsCheck = [ "pygtfs" ];

  meta = with lib; {
    description = "Python module for GTFS";
    mainProgram = "gtfs2db";
    homepage = "https://github.com/jarondl/pygtfs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
