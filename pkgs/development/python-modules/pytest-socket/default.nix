{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-socket";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "miketheman";
    repo = pname;
    rev = version;
    sha256 = "1jbzkyp4xki81h01yl4vg3nrg9b6shsk1ryrmkaslffyhrqnj8zh";
  };

  propagatedBuildInputs = [
    pytest
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  # unsurprisingly pytest-socket require network for majority of tests
  # to pass...
  doCheck = false;

  meta = with lib; {
    description = "Pytest Plugin to disable socket calls during tests";
    homepage = https://github.com/miketheman/pytest-socket;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
