{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, aiohttp
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-aiohttp";
  version = "1.0.4";

  format = "setuptools";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "39ff3a0d15484c01d1436cbedad575c6eafbf0f57cdf76fb94994c97b5b8c5a4";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiohttp
    pytest-asyncio
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # pytest 7.2.0 incompatibilities
    # https://github.com/aio-libs/pytest-aiohttp/issues/50
    "tests/test_fixtures.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/aio-libs/pytest-aiohttp/";
    changelog = "https://github.com/aio-libs/pytest-aiohttp/blob/v${version}/CHANGES.rst";
    description = "Pytest plugin for aiohttp support";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
