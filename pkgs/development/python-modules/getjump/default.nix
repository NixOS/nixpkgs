{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pillow,
  hatchling,
  pythonOlder,
  requests,
  rich,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "getjump";
  version = "2.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FfAwPCbj+0wL+Lgk17peco/ogrsaa6Js+Ay5fqgPUPw=";
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

  meta = with lib; {
    description = "Get and save images from jump web viewer";
    homepage = "https://github.com/eggplants/getjump";
    changelog = "https://github.com/eggplants/getjump/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "jget";
  };
}
