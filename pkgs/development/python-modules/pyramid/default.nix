{ lib
, buildPythonPackage
, fetchPypi
, webtest
<<<<<<< HEAD
, zope-component
=======
, zope_component
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NyE4pzjkIWU1zHbczm7d1aGqypUTDyNU+4NCZMBvGN4=";
=======
    hash = "sha256-+r/XRQOeJq1bCRX8OW6HJcD4o9F7lB+WEezR7XbP59o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    zope-component
=======
    zope_component
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
