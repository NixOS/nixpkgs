{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, zope_interface
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lazr-delegates";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "lazr.delegates";
    inherit version;
    hash = "sha256-UNT7iHK5UuV6SOEmEOVQ+jBm7rV8bGx1tqUUJBi6wZw=";
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
    changelog = "https://git.launchpad.net/lazr.delegates/tree/NEWS.rst?h=${version}";
    license = licenses.lgpl3Only;
  };
}
