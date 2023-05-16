{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pytestCheckHook
, zope_interface
, zope_testrunner
=======
, zope_interface
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sphinx
}:

buildPythonPackage rec {
  pname = "repoze.sphinx.autointerface";
  version = "1.0.0";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SGvxQjpGlrkVPkiM750ybElv/Bbd6xSwyYh7RsYOKKE=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
    zope_interface
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    zope_testrunner
  ];
=======
  propagatedBuildInputs = [ zope_interface sphinx ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/repoze/repoze.sphinx.autointerface";
    description = "Auto-generate Sphinx API docs from Zope interfaces";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
