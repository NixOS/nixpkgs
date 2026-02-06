{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pillow,
  hatchling,
  requests,
  rich,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "getjump";
  version = "2.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AX8WffzcqBYqo8DzXXbhfqOMd7U5VpWx4MTKhUXLJeQ=";
  };

  pythonRelaxDeps = [
    "pillow"
    "rich"
  ];

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    beautifulsoup4
    pillow
    requests
    rich
  ];

  pythonImportsCheck = [ "getjump" ];

  # all the tests talk to the internet
  doCheck = false;

  meta = {
    description = "Get and save images from jump web viewer";
    homepage = "https://github.com/eggplants/getjump";
    changelog = "https://github.com/eggplants/getjump/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jget";
  };
}
