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
  version = "0.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PE66ogjfzj6cW3+UD5nZHSt6zg7b+j6Q4ACznE4j0j8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pytest
  ];

  checkInputs = [
    flaky
    hypothesis
    flaky
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_asyncio"
  ];

  meta = with lib; {
    description = "Library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
