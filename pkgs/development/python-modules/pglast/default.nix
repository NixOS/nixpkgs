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
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "115067100fbb9eb36f530d94b64b4e1e36a8d304537af0847d562ff9ed399c05";
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
