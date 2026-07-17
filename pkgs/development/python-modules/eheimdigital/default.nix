{
  aiohttp,
  buildPythonPackage,
  fetchFromCodeberg,
  hatchling,
  lib,
  yarl,
}:

buildPythonPackage rec {
  pname = "eheimdigital";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "autinerd";
    repo = "eheimdigital";
    tag = version;
    hash = "sha256-aAV63mdgBQ1kbLGOERkUm67S4A+Fyq+0ihllTTGe1mc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "eheimdigital" ];

  # upstream tests are dysfunctional
  doCheck = false;

  meta = {
    changelog = "https://codeberg.org/autinerd/eheimdigital/releases/tag/${src.tag}";
    description = "Offers a Python API for the EHEIM Digital smart aquarium devices";
    homepage = "https://codeberg.org/autinerd/eheimdigital";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
