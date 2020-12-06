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
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72652b9edc7bdbfc9c3192235fb2fa1b2fb73a681613368fcaec747d7f5e479f";
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
