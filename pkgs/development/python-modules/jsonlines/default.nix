{ lib, fetchFromGitHub, buildPythonPackage, six
, flake8, pep8-naming, pytest, pytest-cov }:

buildPythonPackage rec {
  pname = "jsonlines";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = pname;
    rev = version;
    sha256 = "1242bvk208vjaw8zl1d7ydb0i05v8fwdgi92d3bi1vaji9s2hv65";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ flake8 pep8-naming pytest pytest-cov ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python library to simplify working with jsonlines and ndjson data";
    homepage = "https://github.com/wbolster/jsonlines";
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };
}
