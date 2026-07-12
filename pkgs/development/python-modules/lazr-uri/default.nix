{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lazr-uri";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr_uri";
    inherit version;
    hash = "sha256-DkWFTrImh5WN+4B2Vf9+CVsXZb5kniTMxYGTTQM307Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  pythonImportsCheck = [ "lazr.uri" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonNamespaces = [ "lazr" ];

  meta = {
    description = "Self-contained, easily reusable library for parsing, manipulating";
    homepage = "https://launchpad.net/lazr.uri";
    changelog = "https://git.launchpad.net/lazr.uri/tree/NEWS.rst?h=${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
  };
}
