{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  # tests
  freezegun,
  mock,
  pytestCheckHook,
  sure,
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "1.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IN4OXdWhgpLTbZKMw9blL4sqxz2uxA1B62Le4VSTO2g=";
  };

  patches = [
    # https://github.com/gabrielfalcao/HTTPretty/pull/485
    # https://github.com/gabrielfalcao/HTTPretty/pull/485
    ./urllib-2.3.0-compat.patch
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    freezegun
    mock
    pytestCheckHook
    sure
  ];

  disabledTestPaths = [
    "tests/bugfixes"
    "tests/functional"
    "tests/pyopenssl"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://httpretty.readthedocs.org/";
    description = "HTTP client request mocking tool";
    license = lib.licenses.mit;
  };
}
