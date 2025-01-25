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
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "autinerd";
    repo = "eheimdigital";
    tag = version;
    hash = "sha256-fzvQrguwZoaQCoJlXzFCF7WUZpBe0EMQNcyKnmhQ4l8=";
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
