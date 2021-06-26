{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-ingv-centro-nazionale-terremoti-client";
  version = "0.5";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ingv-centro-nazionale-terremoti-client";
    rev = "v${version}";
    sha256 = "1pd0qsr0n8f1169p2nz8s0zrbrxh0rdzaxdb3jmdymzp4xz28wb0";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "georss_ingv_centro_nazionale_terremoti_client" ];

  meta = with lib; {
    description = "Python library for accessing the INGV Centro Nazionale Terremoti GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
