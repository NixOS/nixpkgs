{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pythonOlder
, aenum
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1442ae2cfc6427e9a8fcc2dc18d9ecfcaa1b16eba237fdcf0b2b13912eab9a86";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = lib.optionals (pythonOlder "3.6") [ aenum ];

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/lelit/pglast";
    description = "PostgreSQL Languages AST and statements prettifier";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marsam ];
  };
}
