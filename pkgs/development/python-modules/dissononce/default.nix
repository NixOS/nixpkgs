{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  pytest,
  cryptography,
  transitions,
}:

buildPythonPackage rec {
  pname = "dissononce";
  version = "0.34.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "dissononce";
    rev = version;
    sha256 = "0hn64qfr0d5npmza6rjyxwwp12k2z2y1ma40zpl104ghac6g3mbs";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test tests/
  '';

  dependencies = [
    cryptography
    transitions
  ];

  meta = {
    homepage = "https://pypi.org/project/dissononce/";
    license = lib.licenses.mit;
    description = "Python implementation for Noise Protocol Framework";
  };
}
