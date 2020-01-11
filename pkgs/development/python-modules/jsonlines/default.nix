{ lib, fetchFromGitHub, buildPythonPackage, six
, flake8, pep8-naming, pytest, pytestcov, pytestpep8 }:

buildPythonPackage rec {
  pname = "jsonlines";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = pname;
    rev = version;
    sha256 = "1f8zsqy8p9a41gqg2a5x7sppc5qhhq7gw58id2aigb270yxzs7jw";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ flake8 pep8-naming pytest pytestcov pytestpep8 ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python library to simplify working with jsonlines and ndjson data";
    homepage = https://github.com/wbolster/jsonlines;
    maintainers = with maintainers; [ sondr3 ];
    license = licenses.bsd3;
  };
}
