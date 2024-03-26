{ buildPythonPackage, fetchFromGitHub, lib, pytest, cryptography, transitions }:

buildPythonPackage rec {
  pname = "dissononce";
  version = "0.34.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "dissononce";
    rev = version;
    sha256 = "0hn64qfr0d5npmza6rjyxwwp12k2z2y1ma40zpl104ghac6g3mbs";
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    HOME=$(mktemp -d) py.test tests/
  '';

  propagatedBuildInputs = [ cryptography transitions ];

  meta = with lib; {
    homepage = "https://pypi.org/project/dissononce/";
    license = licenses.mit;
    description = "A python implementation for Noise Protocol Framework";
  };
}
