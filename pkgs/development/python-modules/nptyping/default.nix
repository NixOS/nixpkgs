{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, beartype
, invoke
, numpy
, pandas
, feedparser
}:

buildPythonPackage rec {
  pname = "nptyping";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hz4YrcvARCAA7TXapmneIwle/F4pzcIYLPSmiFHC0VQ=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    beartype
    feedparser
    invoke
    pandas
    pytestCheckHook
  ];

  disabledTests = [
    # tries to download data
    "test_pandas_stubs_fork_is_synchronized"
  ];

  disabledTestPaths = [
    # missing pyright import:
    "tests/test_pyright.py"
    # can't find mypy stubs for pandas:
    "tests/test_mypy.py"
    "tests/pandas_/test_mypy_dataframe.py"
    # typeguard release broke nptyping compatibility:
    "tests/test_typeguard.py"
    # tries to build wheel of package, broken/unnecessary under Nix:
    "tests/test_wheel.py"
  ];

  pythonImportsCheck = [
    "nptyping"
  ];

  meta = with lib; {
    description = "Type hints for numpy";
    homepage = "https://github.com/ramonhagenaars/nptyping";
    changelog = "https://github.com/ramonhagenaars/nptyping/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
