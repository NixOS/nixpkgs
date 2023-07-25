{ lib
, buildPythonPackage
, fetchPypi
, webtest
, zope_component
, hupper
, pastedeploy
, plaster
, plaster-pastedeploy
, repoze_lru
, translationstring
, venusian
, webob
, zope_deprecation
, zope_interface
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyramid";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+r/XRQOeJq1bCRX8OW6HJcD4o9F7lB+WEezR7XbP59o=";
  };

  propagatedBuildInputs = [
    hupper
    pastedeploy
    plaster
    plaster-pastedeploy
    repoze_lru
    translationstring
    venusian
    webob
    zope_deprecation
    zope_interface
  ];

  nativeCheckInputs = [
    webtest
    zope_component
  ];

  pythonImportsCheck = [
    "pyramid"
  ];

  meta = with lib; {
    description = "Python web framework";
    homepage = "https://trypyramid.com/";
    changelog = "https://github.com/Pylons/pyramid/blob/${version}/CHANGES.rst";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
