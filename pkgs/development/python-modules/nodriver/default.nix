{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  deprecated,
  mss,
  websockets,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nodriver";
  version = "0.37";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FF/E0hNZvo26Urtgw+nBH5Rmk7UCaqAsckCLDMuCK0A=";
  };

  disabled = pythonOlder "3.9";

  dependencies = [
    deprecated
    mss
    websockets
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "nodriver" ];
  # no tests in upstream
  doCheck = false;

  meta = {
    homepage = "https://github.com/ultrafunkamsterdam/nodriver";
    license = lib.licenses.agpl3Only;
    description = "Web automation framework which can bypass bot detection";
    longDescription = ''
      Successor of Undetected-Chromedriver. Providing a blazing fast framework for web
      automation, webscraping, bots and any other creative ideas which are normally
      hindered by annoying anti bot systems like Captcha / CloudFlare / Imperva / hCaptcha
    '';
    maintainers = with lib.maintainers; [
      liammurphy14
      toasteruwu
    ];
  };
}
