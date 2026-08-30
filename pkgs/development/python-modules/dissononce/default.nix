{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest,
  cryptography,
  transitions,
}:

buildPythonPackage rec {
  pname = "dissononce";
  version = "0.34.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "dissononce";
    rev = version;
    hash = "sha256-etXxDFPwERDo/YCoGrz4YopwOe9eZqN+vbY0kB0mxkI=";
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test tests/
  '';

  propagatedBuildInputs = [
    cryptography
    transitions
  ];

  meta = {
    homepage = "https://pypi.org/project/dissononce/";
    license = lib.licenses.mit;
    description = "Python implementation for Noise Protocol Framework";
  };
}
