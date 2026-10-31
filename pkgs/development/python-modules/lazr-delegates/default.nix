{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools_80,
  zope-interface,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lazr-delegates";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr_delegates";
    inherit version;
    hash = "sha256-uxXCGgG1d6tfrHPaYbFU3W/NN3868C5SIHe0rhH+7Tc=";
  };

  build-system = [ setuptools_80 ];

  dependencies = [ zope-interface ];

  pythonImportsCheck = [ "lazr.delegates" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonNamespaces = [ "lazr" ];

  meta = {
    description = "Easily write objects that delegate behavior";
    homepage = "https://launchpad.net/lazr.delegates";
    changelog = "https://git.launchpad.net/lazr.delegates/tree/NEWS.rst?h=${version}";
    license = lib.licenses.lgpl3Only;
  };
}
