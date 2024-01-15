{ lib, buildPythonPackage, fetchFromGitHub, isPy3k }:

buildPythonPackage rec {
  pname = "python-doi";
  version = "0.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "papis";
    repo = "python-doi";
    rev = "v${version}";
    sha256 = "1wa5inh2a0drjswrnhjv6m23mvbfdgqj2jb8fya7q0armzp7l6fr";
  };

  disabled = !isPy3k;

  meta = with lib; {
    description = "Python library to work with Document Object Identifiers (doi)";
    homepage = "https://github.com/alejandrogallo/python-doi";
    maintainers = with maintainers; [ teto ];
  };
}
