<<<<<<< HEAD
{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "cfgv";
    rev = "refs/tags/v${version}";
    hash = "sha256-P02j53dltwdrlUBG89AI+P2GkXYKTVrQNF15rZt58jw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cfgv"
  ];
=======
{ lib, buildPythonPackage, fetchPypi, isPy27, six }:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736";
  };

  propagatedBuildInputs = [ six ];

  # Tests not included in PyPI tarball
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Validate configuration and produce human readable error messages";
    homepage = "https://github.com/asottile/cfgv";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ nickcao ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
