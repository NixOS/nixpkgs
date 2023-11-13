{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, poetry-core
, pytestCheckHook
, pythonOlder
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "html2image";
  version = "2.0.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vgalin";
    repo = pname;
    rev = version;
    sha256 = "sha256-BDl2Kibp1WOAOYNlXa2aaEgQTitk+OZu72OgytciZYI=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pillow
  ];

  pythonImportsCheck = [ "html2image" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    websocket-client
  ];

  # remove this when upstream releases a new version > 0.19.0
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=0.12" "poetry-core>=1.5.2" \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  meta = with lib; {
    description = "Wrapper around the headless mode of existing web browsers to generate images from URLs";
    homepage = "https://github.com/vgalin/html2image";
    license = licenses.mit;
  };
}
