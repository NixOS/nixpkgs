{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "html2image";
  version = "2.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vgalin";
    repo = "html2image";
    tag = version;
    hash = "sha256-qGp6i4fNmduTZfdxNvYJTAQV/Ovm3XFNOJ8uSj6Ipic=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    websocket-client
  ];

  pythonImportsCheck = [ "html2image" ];

  meta = with lib; {
    description = "Package acting as a wrapper around the headless mode of existing web browsers to generate images from URLs and from HTML+CSS strings or files";
    homepage = "https://github.com/vgalin/html2image";
    changelog = "https://github.com/vgalin/html2image/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
