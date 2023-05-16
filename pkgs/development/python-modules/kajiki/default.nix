{ lib
<<<<<<< HEAD
, babel
, buildPythonPackage
, fetchFromGitHub
, linetable
, pytestCheckHook
, pythonOlder
=======
, buildPythonPackage
, fetchFromGitHub
, babel
, pytz
, nine
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "kajiki";
  version = "0.9.2";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jackrosenthal";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-EbXe4Jh2IKAYw9GE0kFgKVv9c9uAOiFFYaMF8CGaOfg=";
  };

<<<<<<< HEAD
  propagatedBuildInputs = [
    linetable
  ];

  nativeCheckInputs = [
    babel
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "kajiki"
  ];

  meta = with lib; {
    description = "Module provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    changelog = "https://github.com/jackrosenthal/kajiki/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
=======
  propagatedBuildInputs = [ babel pytz nine ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Kajiki provides fast well-formed XML templates";
    homepage = "https://github.com/nandoflorestan/kajiki";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
