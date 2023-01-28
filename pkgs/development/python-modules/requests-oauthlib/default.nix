{ lib
, buildPythonPackage
, fetchPypi
, mock
, oauthlib
, pytestCheckHook
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "requests-oauthlib";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-db6sSkeIHuuU1epdatMe+IhWr/4jMrmq+1LGRSzPDXo=";
  };

  propagatedBuildInputs = [ oauthlib requests ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    requests-mock
  ];

  # Exclude tests which require network access
  disabledTests = [
    "testCanPostBinaryData"
    "test_content_type_override"
    "test_url_is_native_str"
  ];

  pythonImportsCheck = [ "requests_oauthlib" ];

  meta = with lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = "https://github.com/requests/requests-oauthlib";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ prikhi ];
  };
}
