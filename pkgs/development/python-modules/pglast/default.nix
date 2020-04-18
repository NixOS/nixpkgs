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
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a26ba77127b363446955e8a5317b3194defb1c1bb9d2ed5e7d4830fd4f066d97";
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
