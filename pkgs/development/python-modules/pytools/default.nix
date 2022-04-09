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
  version = "2022.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GXqs9uH11gxxW5JDh5Kst3Aq7Vnrv7FH+oTtp4DlT+4=";
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
