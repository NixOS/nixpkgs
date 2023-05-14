{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, requests
, tqdm
, nose
, vcrpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "habanero";
  version = "1.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sckott";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-IQp85Cigs0in3X07a9d45nMC3X2tAkPzl5hFVhfr00o=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [
    "habanero"
  ];

  # almost the entirety of the test suite makes network calls
  pytestFlagsArray = [
    "test/test-filters.py"
  ];

  meta = with lib; {
    description = "Python interface to Library Genesis";
    homepage = "https://habanero.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ nico202 ];
  };
}
