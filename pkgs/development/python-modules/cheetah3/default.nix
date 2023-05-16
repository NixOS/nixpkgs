<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cheetah3";
  version = "3.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CheetahTemplate3";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-okQz1wM3k43okKcZDRgHAnn5ScL0Pe1OtUvDBScEamY=";
=======
{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Cheetah3";
  version = "3.2.6.post2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63157d7a00a273b59676b5be5aa817c75c37efc88478231f1a160f4cfb7f7878";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  doCheck = false; # Circular dependency

<<<<<<< HEAD
  pythonImportsCheck = [
    "Cheetah"
  ];

  meta = with lib; {
    description = "A template engine and code generation tool";
    homepage = "http://www.cheetahtemplate.org/";
    changelog = "https://github.com/CheetahTemplate3/cheetah3/releases/tag/${version}";
=======
  meta = with lib; {
    homepage = "http://www.cheetahtemplate.org/";
    description = "A template engine and code generation tool";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ pjjw ];
  };
}
