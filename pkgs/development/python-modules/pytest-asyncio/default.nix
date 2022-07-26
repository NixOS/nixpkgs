{ lib
, buildPythonPackage
, fetchFromGitHub
, flaky
, hypothesis
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.18.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eopKlDKiTvGmqcqw44MKlhvSKswKZd/VDYRpZbuyOqM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  checkInputs = [
    flaky
    hypothesis
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/trio" # pytest-trio causes infinite recursion
  ];

  pythonImportsCheck = [
    "pytest_asyncio"
  ];

  meta = with lib; {
    description = "Library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
