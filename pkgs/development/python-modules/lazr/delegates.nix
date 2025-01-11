{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-interface,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lazr-delegates";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr_delegates";
    inherit version;
    hash = "sha256-rs6yYW5Rtz8yf78SxOwrfXZwy4IL1eT2hRIV+3lsAtw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ zope-interface ];

  pythonImportsCheck = [ "lazr.delegates" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonNamespaces = [ "lazr" ];

  meta = with lib; {
    description = "Easily write objects that delegate behavior";
    homepage = "https://launchpad.net/lazr.delegates";
    changelog = "https://git.launchpad.net/lazr.delegates/tree/NEWS.rst?h=${version}";
    license = licenses.lgpl3Only;
  };
}
