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

buildPythonPackage (finalAttrs: {
  pname = "getjump";
  version = "2.10.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ui9H4gVpo90UQ/sm2h58um0ZFcXrDPe6kaw4S91rAhw=";
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
    changelog = "https://github.com/eggplants/getjump/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jget";
  };
})
