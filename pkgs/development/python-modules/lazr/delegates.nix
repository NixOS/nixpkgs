{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, zope_interface
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lazr-delegates";
  version = "2.0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr.delegates";
    inherit version;
    hash = "sha256-3e0wLHv85Xmq2NXi8uNnLckgzI2RAVqQRderJAuituU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    zope_interface
  ];

  pythonImportsCheck = [
    "lazr.delegates"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonNamespaces = [
    "lazr"
  ];

  meta = with lib; {
    description = "Easily write objects that delegate behavior";
    homepage = "https://launchpad.net/lazr.delegates";
    changelog = "https://git.launchpad.net/lazr.delegates/tree/lazr/delegates/docs/NEWS.rst?h=${version}";
    license = licenses.lgpl3Only;
  };
}
