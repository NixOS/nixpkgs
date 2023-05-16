{ lib
, aiosmtpd
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, trustme
}:

buildPythonPackage rec {
  pname = "aiosmtplib";
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cole";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Wo9WH3fwGN1upLAyj6aThxpQE7hortISjaCATTPee40=";
=======
    hash = "sha256-Py/44J9J8FdrsSpEM2/DR2DQH8x8Ub7y0FPIN2gcmmA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    aiosmtpd
    hypothesis
    pytest-asyncio
    pytestCheckHook
    trustme
  ];

  pythonImportsCheck = [
    "aiosmtplib"
  ];

  meta = with lib; {
    description = "Module which provides a SMTP client";
    homepage = "https://github.com/cole/aiosmtplib";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
