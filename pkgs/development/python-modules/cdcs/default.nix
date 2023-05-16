{ lib
, buildPythonPackage
, fetchFromGitHub
, ipython
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools
, tqdm
}:

buildPythonPackage rec {
  pname = "cdcs";
<<<<<<< HEAD
  version = "0.2.2";
=======
  version = "0.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-WiNjMMcpp5K+Re44ryB7LNzr2LnnYzLZ5b0iT7u1ZiA=";
=======
    # https://github.com/usnistgov/pycdcs/issues/1
    rev = "3aeaeb4782054a220e916c189ffe440d113b571d";
    hash = "sha256-OsabgO2B2PRhU3DVvkK+f9VLOMqctl4nyCETxLtzwNs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ipython
    numpy
    pandas
    requests
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "cdcs"
  ];

  meta = with lib; {
    description = "Python client for performing REST calls to configurable data curation system (CDCS) databases";
    homepage = "https://github.com/usnistgov/pycdcs";
<<<<<<< HEAD
    changelog = "https://github.com/usnistgov/pycdcs/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
