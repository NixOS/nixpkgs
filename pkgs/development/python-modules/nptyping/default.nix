{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, beartype
, invoke
, mypy
, numpy
, pandas
, feedparser
, typeguard
}:

buildPythonPackage rec {
  pname = "nptyping";
  version = "2.4.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jV2MVMP/tlYN3djoViemGaJyzREoOJJamwG97WFhIvc=";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [
    beartype feedparser invoke mypy pandas pytestCheckHook typeguard
  ];

  # tries to download data
  disabledTests = [ "test_pandas_stubs_fork_is_synchronized" ];
  disabledTestPaths = [
    # missing pyright import:
    "tests/test_pyright.py"
    # can't find mypy stubs for pandas:
    "tests/test_mypy.py"
    "tests/pandas_/test_mypy_dataframe.py"
    # tries to build wheel of package, broken/unnecessary under Nix:
    "tests/test_wheel.py"
  ];

  pythonImportsCheck = [
    "nptyping"
  ];

  meta = with lib; {
    description = "Type hints for numpy";
    homepage = "https://github.com/ramonhagenaars/nptyping";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
