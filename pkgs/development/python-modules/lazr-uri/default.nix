{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lazr-uri";
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr_uri";
    inherit version;
    hash = "sha256-7Qz28zPkUBFHUq+xzgwpnDasSxCQY+tQNUxPh/glo+4=";
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
