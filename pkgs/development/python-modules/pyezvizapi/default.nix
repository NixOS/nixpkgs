{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  paho-mqtt,
  pandas,
  pycryptodome,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "pyezvizapi";
  version = "1.0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RenierM26";
    repo = "pyEzvizApi";
    tag = version;
    hash = "sha256-BuGBEYoAZ8m5OUwzNUQC84lll5sP0BZq6bVRRCHsGcI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    paho-mqtt
    pandas
    pycryptodome
    requests
    xmltodict
  ];

  pythonImportsCheck = [ "pyezvizapi" ];

  # test_cam_rtsp.py is not actually a unit test
  doCheck = false;

  meta = {
    description = "Python interface for for Ezviz cameras";
    homepage = "https://github.com/RenierM26/pyEzvizApi";
    changelog = "https://github.com/RenierM26/pyEzvizApi/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "pyezviz";
  };
}
