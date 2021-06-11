{ lib
, buildPythonPackage
, dateparser
, fetchFromGitHub
, haversine
, pytestCheckHook
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "georss-client";
  version = "0.13";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-client";
    rev = "v${version}";
    sha256 = "1pvx2qb8gs2f7bb8xxq689ydxirsl3bcgsbi5qv5klc4c051dj8i";
  };

  propagatedBuildInputs = [
    haversine
    xmltodict
    requests
    dateparser
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "georss_client" ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-georss-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
