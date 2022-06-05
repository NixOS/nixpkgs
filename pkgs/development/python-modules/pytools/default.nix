{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, decorator
, numpy
, platformdirs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2022.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XoJBAYgKJGNUdWNliAplu0FvaoyrZRO2j8u0j7oJD8s=";
  };

  propagatedBuildInputs = [
    decorator
    numpy
    platformdirs
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytools"
    "pytools.batchjob"
    "pytools.lex"
  ];

  meta = {
    homepage = "https://github.com/inducer/pytools/";
    description = "Miscellaneous Python lifesavers.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
