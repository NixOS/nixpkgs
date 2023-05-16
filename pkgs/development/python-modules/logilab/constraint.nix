<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, logilab-common
, pip
, six
, pytestCheckHook
, setuptools
}:
=======
{ lib, buildPythonPackage, fetchPypi, logilab-common, six }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "logilab-constraint";
  version = "0.6.2";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jk6wvvcDEeHfy7dUcjbnzFIeGBYm5tXzCI26yy+t2qs=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    importlib-metadata
    pip
  ];

  propagatedBuildInputs = [
    logilab-common
    setuptools
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # avoid ModuleNotFoundError: No module named 'logilab.common' due to namespace
    rm -r logilab
  '';

  disabledTests = [
    # these tests are abstract test classes intended to be inherited
    "Abstract"
  ];

  pythonImportsCheck = [ "logilab.constraint" ];

  meta = with lib; {
    description = "logilab-database provides some classes to make unified access to different";
    homepage = "https://forge.extranet.logilab.fr/open-source/logilab-constraint";
    changelog = "https://forge.extranet.logilab.fr/open-source/logilab-constraint/-/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ ];
=======
  propagatedBuildInputs = [
    logilab-common six
  ];


  meta = with lib; {
    description = "logilab-database provides some classes to make unified access to different";
    homepage = "https://www.logilab.org/project/logilab-database";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

