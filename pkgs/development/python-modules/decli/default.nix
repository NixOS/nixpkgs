<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
=======
{ buildPythonPackage
, lib
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "decli";
<<<<<<< HEAD
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "woile";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FZYKNKkQExx/YBn5y/W0+0aMlenuwEctYTL7LAXMZGE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "decli"
  ];
=======
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8s3lUDSnXIGcYwx2VahExhLyWYxCwhKZFgRl32rUY60=";
  };

  pythonImportsCheck = [ "decli" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Minimal, easy to use, declarative command line interface tool";
    homepage = "https://github.com/Woile/decli";
<<<<<<< HEAD
    changelog = "https://github.com/woile/decli/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
