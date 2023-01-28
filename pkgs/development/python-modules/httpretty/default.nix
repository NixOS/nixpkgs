{ lib
, buildPythonPackage
, fetchPypi
, sure
, six
, pytest
, freezegun
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "1.1.4";

  # drop this for version > 0.9.7
  # Flaky tests: https://github.com/gabrielfalcao/HTTPretty/pull/394
  doCheck = lib.versionAtLeast version "0.9.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20de0e5dd5a18292d36d928cc3d6e52f8b2ac73daec40d41eb62dee154933b68";
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
