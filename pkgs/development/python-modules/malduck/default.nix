{ lib
, buildPythonPackage
, capstone
, click
, cryptography
, dnfile
, fetchFromGitHub
, pefile
, pycryptodomex
, pyelftools
, pythonOlder
, pytestCheckHook
, typing-extensions
, yara-python
}:

buildPythonPackage rec {
  pname = "malduck";
<<<<<<< HEAD
  version = "4.3.2";
=======
  version = "4.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-3joIfhQBJzKdoU3FNW/yAHsQa/lMMbw3wGEQTyOBrOQ=";
=======
    hash = "sha256-1gwJhlhRLnh01AIJj07Wpba8X7V5AfACuJmZX+cfT6Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    capstone
    click
    cryptography
    dnfile
    pefile
    pycryptodomex
    pyelftools
    typing-extensions
    yara-python
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pefile==2019.4.18" "pefile" \
      --replace "dnfile==0.11.0" "dnfile"
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "malduck"
  ];

  meta = with lib; {
    description = "Helper for malware analysis";
    homepage = "https://github.com/CERT-Polska/malduck";
    changelog = "https://github.com/CERT-Polska/malduck/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
<<<<<<< HEAD
=======
    # Compatibility issues with yara-python v4.3.0
    # https://github.com/CERT-Polska/malduck/issues/88
    broken = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
