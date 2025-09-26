{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "python-doi";
  version = "0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "papis";
    repo = "python-doi";
    rev = "v${version}";
    sha256 = "sha256-c5Wo/bJuHwAG7XOy4Re9joYw14jWZ6QaRB4Wsk8StL0=";
  };

  disabled = !isPy3k;

  meta = with lib; {
    description = "Python library to work with Document Object Identifiers (doi)";
    homepage = "https://github.com/papis/python-doi";
    maintainers = with maintainers; [ teto ];
  };
}
