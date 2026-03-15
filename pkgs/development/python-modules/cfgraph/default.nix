{
  lib,
  fetchPypi,
  buildPythonPackage,
  rdflib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "CFGraph";
  version = "0.2.1";
  format = "setuptools";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tX/nBEoQuP9lqjqKjdx9TNd79RG0LlconNUsvCn4/nQ=";
  };

  build-system = [ setuptools ];
  propagatedBuildInputs = [ rdflib ];

  pythonImportsCheck = [ "CFGraph" ];

  meta = {
    description = "Flatten collections in RDFLib graphs";
    homepage = "https://github.com/hsolbrig/CFGraph";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
