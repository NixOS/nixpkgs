{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyparsing,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "asn1ate";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    hash = "sha256-hdQJtgNGakuiQrEJwSqOy19R7EkEM6ceyE1jrx/ZEN0=";
    tag = "v${finalAttrs.version}";
    owner = "schneider-electric";
    repo = "asn1ate";
  };

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];

  pythonImportsCheck = [ "asn1ate" ];

  meta = {
    description = "Python library for translating ASN.1 into other forms";
    homepage = "https://github.com/schneider-electric/asn1ate";
    mainProgram = "asn1ate";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
