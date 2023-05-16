{ lib
, buildPythonPackage
, editdistance-s
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, ukkonen
}:

buildPythonPackage rec {
  pname = "identify";
<<<<<<< HEAD
  version = "2.5.28";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "2.5.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-pGSXXsA+gIIIZbnwa22EmizZT65MqZrWd3+o47VatBs=";
=======
    rev = "v${version}";
    hash = "sha256-L73M+lWonuT7sSk+piBkZZJtxxeBvZ1XUXUypvS65G0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    editdistance-s
    pytestCheckHook
    ukkonen
  ];

  pythonImportsCheck = [
    "identify"
  ];

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
