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
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbd38425636e68527abdb4397422b2ffc1eab175932909444520bec39ac78d24";
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
