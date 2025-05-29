{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  yarl,
}:

buildPythonPackage rec {
  pname = "eheimdigital";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "autinerd";
    repo = "eheimdigital";
    tag = version;
    hash = "sha256-Jg5jVJAH6y2yrospcPJwHc/B0yd5ZRSXC6T7gYk7Sxs=";
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
    changelog = "https://github.com/autinerd/eheimdigital/releases/tag/${src.tag}";
    description = "Offers a Python API for the EHEIM Digital smart aquarium devices";
    homepage = "https://github.com/autinerd/eheimdigital";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
