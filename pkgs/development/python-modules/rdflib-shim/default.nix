{
  lib,
  fetchPypi,
  buildPythonPackage,
  pbr,
  rdflib,
  rdflib-jsonld,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rdflib-shim";
  version = "1.0.3";
  format = "setuptools";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "rdflib_shim";
    inherit version;
    hash = "sha256-2VXRHimGqrQraDDKVqxryciTq9HQSaFhxt4vG5nU/A0=";
  };

  build-system = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [
    rdflib
    rdflib-jsonld
  ];

  pythonImportsCheck = [ "rdflib_shim" ];

  meta = {
    description = "Shim for RDFLib version incompatibilities";
    homepage = "https://github.com/hsolbrig/rdflib-shim";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
