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
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0smaxs5ixng4z0k6dsgmm6s972ka3p6a2ykdpnl23mqzlw0ic9ml";
  };

  propagatedBuildInputs = [ oauthlib requests ];

  checkInputs = [
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
