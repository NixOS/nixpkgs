<<<<<<< HEAD
{ lib
, buildPythonPackage
, unittestCheckHook
, fetchPypi
, pythonOlder
, glibcLocales
}:

buildPythonPackage rec {
  pname = "pystache";
  version = "0.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nyONWgbxiEPg1JHY5OKS3AP+1qVMsKXDS+N6P6qXMXQ=";
=======
{ lib, buildPythonPackage, unittestCheckHook, fetchPypi, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "pystache";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93bf92b2149a4c4b58d12142e2c4c6dd5c08d89e4c95afccd4b6efe2ee1d470d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  LC_ALL = "en_US.UTF-8";

<<<<<<< HEAD
  buildInputs = [
    glibcLocales
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "pystache"
  ];
=======
  buildInputs = [ glibcLocales ];

  # SyntaxError Python 3
  # https://github.com/defunkt/pystache/issues/181
  doCheck = !isPy3k;

  nativeCheckInputs = [ unittestCheckHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A framework-agnostic, logic-free templating system inspired by ctemplate and et";
    homepage = "https://github.com/defunkt/pystache";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
