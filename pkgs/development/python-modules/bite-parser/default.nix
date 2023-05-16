{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, pytest-asyncio
, pytestCheckHook
<<<<<<< HEAD
=======
, typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "bite-parser";
<<<<<<< HEAD
  version = "0.2.3";
=======
  version = "0.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchPypi {
    pname = "bite_parser";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-5ZdmOhnxpBI4XGgT4n8JEriqOEkiUZ1Cc96/pyluhe4=";
=======
    hash = "sha256-mBghKgrNv4ZaRNowo7csWekmqrI0xAVKJKowSeumr4g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
<<<<<<< HEAD
=======
    typing-extensions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [ "bite" ];

  meta = {
    description = "Asynchronous parser taking incremental bites out of your byte input stream";
    homepage = "https://github.com/jgosmann/bite-parser";
    changelog = "https://github.com/jgosmann/bite-parser/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
