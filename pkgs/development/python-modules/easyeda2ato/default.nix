{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pydantic,
  requests,
}:

buildPythonPackage rec {
  pname = "easyeda2ato";
  version = "0.2.7";
  pyproject = true;

  # repo version does not match
  src = fetchPypi {
    inherit pname version;

    hash = "sha256-bHhBN+h9Vx9Q4wZVKxMzkEEXzV7hKoQz8i+JpkSFsYA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    requests
  ];

  pythonImportsCheck = [ "easyeda2kicad" ];

  doCheck = false; # no tests

  meta = {
    description = "Convert any LCSC components (including EasyEDA) to KiCad library";
    homepage = "https://github.com/uPesy/easyeda2kicad.py";
    changelog = "https://github.com/uPesy/easyeda2kicad.py/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "easyeda2kicad";
  };
}
