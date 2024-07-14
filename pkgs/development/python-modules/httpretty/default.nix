{
  lib,
  buildPythonPackage,
  fetchPypi,
  sure,
  six,
  pytest,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "1.1.4";
  format = "setuptools";

  # drop this for version > 0.9.7
  # Flaky tests: https://github.com/gabrielfalcao/HTTPretty/pull/394
  doCheck = lib.versionAtLeast version "0.9.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IN4OXdWhgpLTbZKMw9blL4sqxz2uxA1B62Le4VSTO2g=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    sure
    freezegun
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/bugfixes"
    "tests/functional"
    "tests/pyopenssl"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://httpretty.readthedocs.org/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };
}
