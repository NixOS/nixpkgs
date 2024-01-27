{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-generic-client";
  version = "0.7";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-generic-client";
    rev = "v${version}";
    hash = "sha256-58NpACrJK29NUnx3RrsLFPPo+6A/JlIlkrv8N9juMu0=";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "georss_generic_client" ];

  meta = with lib; {
    description = "Python library for accessing generic GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-georss-generic-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
