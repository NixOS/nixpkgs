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
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8463d60b9065daf26e3c0fa6e7515d2a4594847ab417be018858832a475105f1";
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
