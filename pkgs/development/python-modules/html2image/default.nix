{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "html2image";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vgalin";
    repo = "html2image";
    rev = "refs/tags/${version}";
    hash = "sha256-k5y89nUF+fhUj9uzTAPkkAdOb2TsTL2jm/ZXwHlxu/A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail poetry.masonry.api poetry.core.masonry.api \
    --replace-fail "poetry>=" "poetry-core>="
  '';

  build-system = [ poetry-core ];

  dependencies = [
    requests
    websocket-client
  ];

  pythonImportsCheck = [ "html2image" ];

  meta = with lib; {
    description = "Package acting as a wrapper around the headless mode of existing web browsers to generate images from URLs and from HTML+CSS strings or files";
    homepage = "https://github.com/vgalin/html2image";
    changelog = "https://github.com/vgalin/html2image/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
