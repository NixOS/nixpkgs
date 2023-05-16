{ lib
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, poetry-core
, psutil
, pytestCheckHook
, python-gnupg
, pythonOlder
, pythonRelaxDepsHook
, sentry-sdk
, tomli
}:

buildPythonPackage rec {
  pname = "notus-scanner";
<<<<<<< HEAD
  version = "22.6.0";
=======
  version = "22.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Ih6Uz7dTVMNCBsLcDsslyIzttg+IDBW3B+Ixpp7sz1Y=";
=======
    hash = "sha256-h+jZWjDvTfW9XjoGhWYX08hgJ/Qp64MEaqHHwnahnC4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonRelaxDeps = [
    "python-gnupg"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    paho-mqtt
    psutil
    python-gnupg
    sentry-sdk
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "notus.scanner"
  ];

  meta = with lib; {
    description = "Helper to create results from local security checks";
    homepage = "https://github.com/greenbone/notus-scanner";
    changelog = "https://github.com/greenbone/notus-scanner/releases/tag/v${version}";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
