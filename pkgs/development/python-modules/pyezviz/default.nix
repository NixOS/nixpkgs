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
  version = "1.0.0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "baqs";
    repo = "pyEzviz";
    tag = version;
    hash = "sha256-KtAqmM4k1o89lG/yb2er1r792zGyNx+TgIQhELr3yTc=";
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
    changelog = "https://github.com/BaQs/pyEzviz/releases/tag/${src.tag}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pyezviz";
  };
}
