{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  oauthlib,
  pytestCheckHook,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "requests-oauthlib";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s9/669iE2M13hJQ2lgOp57WNKREb9rQb3C3NhyA69Ok=";
  };

  propagatedBuildInputs = [
    oauthlib
    requests
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [
    # Exclude tests which require network access
    "testCanPostBinaryData"
    "test_content_type_override"
    "test_url_is_native_str"
    # too narrow time comparison
    "test_fetch_access_token"
  ];

  # Requires selenium and chrome
  disabledTestPaths = [ "tests/examples/test_native_spa_pkce_auth0.py" ];

  pythonImportsCheck = [ "requests_oauthlib" ];

  meta = with lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = "https://github.com/requests/requests-oauthlib";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ prikhi ];
  };
}
