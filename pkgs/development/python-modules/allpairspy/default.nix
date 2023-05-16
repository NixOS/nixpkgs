<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0wzoQDHB7Tt80ZTlKrNxFutztsgUuin5D2eb80c4PBI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "allpairspy"
  ];
=======
{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9358484c91abe74ba18daf9d6d6904c5be7cc8818397d05248c9d336023c28b1";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = "https://github.com/thombashi/allpairspy";
<<<<<<< HEAD
    changelog = "https://github.com/thombashi/allpairspy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
=======
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
