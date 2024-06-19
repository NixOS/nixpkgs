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
  version = "2.0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vgalin";
    repo = "html2image";
    rev = version;
    hash = "sha256-BDl2Kibp1WOAOYNlXa2aaEgQTitk+OZu72OgytciZYI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    requests
    websocket-client
  ];

  pythonImportsCheck = [ "html2image" ];

  meta = with lib; {
    description = "A package acting as a wrapper around the headless mode of existing web browsers to generate images from URLs and from HTML+CSS strings or files";
    homepage = "https://github.com/vgalin/html2image";
    changelog = "https://github.com/vgalin/html2image/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
