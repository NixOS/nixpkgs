{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-ign-sismologia-client";
  version = "0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ign-sismologia-client";
    rev = "v${version}";
    hash = "sha256-i3VdxntFwieCmB4ihHRSCV5YKDyYytl3XnU/G1LwLhg=";
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
