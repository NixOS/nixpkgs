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
  version = "1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dcbd8061c553b90440741b77fbb274beca84716641a50be8675a6afe6dfbcea2";
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
