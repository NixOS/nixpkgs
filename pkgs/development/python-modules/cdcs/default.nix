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
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
    # https://github.com/usnistgov/pycdcs/issues/1
    rev = "3aeaeb4782054a220e916c189ffe440d113b571d";
    hash = "sha256-OsabgO2B2PRhU3DVvkK+f9VLOMqctl4nyCETxLtzwNs=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
