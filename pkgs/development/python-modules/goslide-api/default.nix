{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "goslide-api";
  version = "0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ualex73";
    repo = "goslide-api";
    tag = version;
    hash = "sha256-s8MtOBNieg0o8U6pkf0e/EF8GtVkb7BgQBP6n/xmKJk=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "goslideapi" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Python API to utilise the Slide Open Cloud and Local API";
    homepage = "https://github.com/ualex73/goslide-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
