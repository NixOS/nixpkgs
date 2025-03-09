{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pandas,
  pycryptodome,
  pythonOlder,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pyezviz";
  version = "0.2.2.4a";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    rev = "refs/tags/${version}";
    hash = "sha256-OgDplQ6TrK2CZbNgJpoYC8TkK1sG73HdpUyHE+2ZTLk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    paho-mqtt
    pandas
    pycryptodome
    requests
    xmltodict
  ];

  # Project has no tests. test_cam_rtsp.py is more a sample for using the module
  doCheck = false;

  pythonImportsCheck = [ "pyezviz" ];

  meta = with lib; {
    description = "Python interface for for Ezviz cameras";
    homepage = "https://github.com/baqs/pyEzviz/";
    changelog = "https://github.com/BaQs/pyEzviz/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pyezviz";
  };
}
