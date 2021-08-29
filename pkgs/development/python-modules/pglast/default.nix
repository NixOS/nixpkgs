{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pythonOlder
, setuptools
, aenum
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2979b38ca5f72cfa0a5db78af2f62d04db6a7647ee7f03eac7a67f9e86e3f5f9";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ setuptools ] ++ lib.optionals (pythonOlder "3.6") [ aenum ];

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
