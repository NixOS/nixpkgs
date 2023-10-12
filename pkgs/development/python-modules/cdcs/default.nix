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
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
    rev = "refs/tags/v${version}";
    hash = "sha256-WiNjMMcpp5K+Re44ryB7LNzr2LnnYzLZ5b0iT7u1ZiA=";
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
    changelog = "https://github.com/usnistgov/pycdcs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
