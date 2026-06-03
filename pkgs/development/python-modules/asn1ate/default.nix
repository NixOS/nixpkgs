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
    sha256 = "1p8hv4gsyqsdr0gafcq497n52pybiqmc22di8ai4nsj60fv0km45";
    rev = "v${finalAttrs.version}";
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
