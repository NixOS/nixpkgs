{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
}:

buildPythonPackage rec {
  pname = "asn1ate";
  format = "setuptools";
  version = "0.6";

  src = fetchFromGitHub {
    hash = "sha256-hdQJtgNGakuiQrEJwSqOy19R7EkEM6ceyE1jrx/ZEN0=";
    rev = "v${version}";
    owner = "schneider-electric";
    repo = "asn1ate";
  };

  propagatedBuildInputs = [ pyparsing ];

  meta = {
    description = "Python library for translating ASN.1 into other forms";
    homepage = "https://github.com/schneider-electric/asn1ate";
    mainProgram = "asn1ate";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
