{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, parameterized
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "moreorless";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "thatch";
    repo = "moreorless";
    rev = "refs/tags/v${version}";
    hash = "sha256-N11iqsxMGgzwW2QYeOoHQaR/aDEuoUnnd/2Mc5culN0=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
  ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "moreorless"
  ];

  pytestFlagsArray = [
    "moreorless/tests/click.py"
    "moreorless/tests/general.py"
    "moreorless/tests/patch.py"
  ];

  meta = with lib; {
    description = "Wrapper to make difflib.unified_diff more fun to use";
    homepage = "https://github.com/thatch/moreorless/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
