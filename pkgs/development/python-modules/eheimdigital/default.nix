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
  version = "1.7.1";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "autinerd";
    repo = "eheimdigital";
    tag = version;
    hash = "sha256-ustTjHWmQJXzgFeLyifPiiZtjFwepVD7zloU8/Qw1gk=";
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
