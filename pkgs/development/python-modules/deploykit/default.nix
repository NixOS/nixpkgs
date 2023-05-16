{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, bash
, openssh
, pytestCheckHook
, pythonOlder
, stdenv
}:

buildPythonPackage rec {
  pname = "deploykit";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-re7r2K9F5FTTVn84WC+wZX30JA9AXQcHK3pLjYglMs8=";
=======
    hash = "sha256-I1vAefWQBBRNykDw38LTNwdiPFxpPkLzCcevYAXO+Zo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    bash
    openssh
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_ssh" ];

  # don't swallow stdout/stderr
  pytestFlagsArray = [ "-s" ];

  pythonImportsCheck = [
    "deploykit"
  ];

  meta = with lib; {
    description = "Execute commands remote via ssh and locally in parallel with python";
    homepage = "https://github.com/numtide/deploykit";
    changelog = "https://github.com/numtide/deploykit/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 zowoq ];
    platforms = platforms.unix;
  };
}
