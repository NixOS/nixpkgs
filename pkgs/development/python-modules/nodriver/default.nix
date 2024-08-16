{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  deprecated,
  mss,
  websockets,
  setuptools,
}:

buildPythonPackage {
  pname = "nodriver";
  version = "0.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultrafunkamsterdam";
    repo = "nodriver";
    rev = "082815916900450485bd14cf1c7a83593e51825d";
    hash = "sha256-MaOCC7yVLDqkpk8YiTov9WZKlYhME2CXHIrllmU0yLg=";
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

