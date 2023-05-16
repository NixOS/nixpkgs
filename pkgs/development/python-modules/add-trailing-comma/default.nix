{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, tokenize-rt
}:

buildPythonPackage rec {
  pname = "add-trailing-comma";
<<<<<<< HEAD
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "2.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "asottile";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-B+wjBy42RwabVz/6qEMGpB0JmwJ9hqSskwcNj4x/B/k=";
=======
    hash = "sha256-/dA3OwBBMjykSYaIbvhJZj9Z8/0+mfL5pW4GqgMgops=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    tokenize-rt
  ];

  pythonImportsCheck = [
    "add_trailing_comma"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A tool (and pre-commit hook) to automatically add trailing commas to calls and literals";
    homepage = "https://github.com/asottile/add-trailing-comma";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
