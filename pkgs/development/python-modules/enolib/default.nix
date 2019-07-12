{ buildPythonPackage, fetchFromGitHub, lib
, pytest, pytestcov, hypothesis, pyyaml
}:

buildPythonPackage rec {
  pname = "enolib";
  version = "0.5.1";

  # Tests are missing in PyPi
  src = fetchFromGitHub {
    owner = "eno-lang";
    repo = "enolib";
    rev = "v${version}";
    sha256 = "0smz9f63az9ndknc62kxaj7y04mkidn3dd2dndr177pp3ywbrmsg";
  };

  # The repository contains the code for all languages.
  # We keep only Python
  patchPhase = ''
    find . ! -name 'python' ! -path . -maxdepth 1 -exec rm -rf {} +
    mv python/* .
    rm -rf python
  '';

  checkInputs=[pytest pytestcov hypothesis pyyaml];
  checkPhase="pytest";

  meta = with lib; {
    description = "Python version of the cross-language eno standard library";
    license = licenses.mit;
    homepage = https://eno-lang.org/enolib/;
    maintainers = with maintainers; [ mredaelli ];
  };
}
