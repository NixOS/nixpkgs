{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  networkx,
  python-dateutil,
  rdflib,
  pydot,
}:

buildPythonPackage rec {
  pname = "prov";
  version = "2.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tNI2zwHDszvf331fZ68k0xxHFvJZ4PtzHo36zz1URp4=";
  };

  propagatedBuildInputs = [
    lxml
    networkx
    python-dateutil
    rdflib
  ];

  nativeCheckInputs = [ pydot ];

  # Multiple tests are out-dated and failing
  doCheck = false;

  pythonImportsCheck = [ "prov" ];

  meta = {
    description = "Python library for W3C Provenance Data Model (PROV)";
    homepage = "https://github.com/trungdong/prov";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
