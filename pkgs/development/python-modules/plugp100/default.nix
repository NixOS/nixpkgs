{
  lib,
  buildPythonPackage,
  certifi,
  jsons,
  requests,
  aiohttp,
  semantic-version,
  cryptography,
  scapy,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "plugp100";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "petretiandrea";
    repo = "plugp100";
    rev = "v${version}";
    hash = "sha256-83umSwYhhoZ5l1ShF+2HHTDGLicj2UVjCWHl9/MtUdU=";
  };

  propagatedBuildInputs = [
    certifi
    jsons
    requests
    aiohttp
    semantic-version
    cryptography
    scapy
  ];

  # Requires local device(s)
  doCheck = false;

  pythonImportsCheck = [
    "plugp100"
  ];

  meta = with lib; {
    changelog = "https://github.com/petretiandrea/plugp100/releases/tag/v${version}";
    description = "Work in progress implementation of tapo protocol";
    homepage = "https://github.com/petretiandrea/plugp100";
    license = licenses.gpl3;
    maintainers = with maintainers; [nyawox];
  };
}
