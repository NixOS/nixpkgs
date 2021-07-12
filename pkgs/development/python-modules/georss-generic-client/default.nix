{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-generic-client";
  version = "0.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-generic-client";
    rev = "v${version}";
    sha256 = "sha256-XVejBbVilq8zrmuyBUd0mNPZ4qysSg9lAe/lhbKT+qs=";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
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
