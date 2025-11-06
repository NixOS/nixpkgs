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
    sha256 = "20de0e5dd5a18292d36d928cc3d6e52f8b2ac73daec40d41eb62dee154933b68";
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

  meta = with lib; {
    homepage = "https://httpretty.readthedocs.org/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };
}
