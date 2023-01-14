{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-ign-sismologia-client";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ign-sismologia-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-OLX6Megl5l8KDnd/G16QJ/wQn5AQc2cZ+LCbjuHFbwo=";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "georss_ign_sismologia_client"
  ];

  meta = with lib; {
    description = "Python library for accessing the IGN Sismologia GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ign-sismologia-client";
    changelog = "https://github.com/exxamalte/python-georss-ign-sismologia-client/blob/v0.6/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
