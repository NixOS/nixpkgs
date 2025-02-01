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
  version = "0.37";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultrafunkamsterdam";
    repo = "nodriver";
    rev = "1bb6003c7f0db4d3ec05fdf3fc8c8e0804260103";
    hash = "sha256-8q+9RX9ugrT6/fjlTSIecVcR6lPdZwg7nF+cSTSLlEc=";
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

