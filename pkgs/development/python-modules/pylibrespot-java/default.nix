{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pylibrespot-java";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uvjustin";
    repo = "pylibrespot-java";
    tag = "v${version}";
    hash = "sha256-aPmyYsO8yBrlPEQXOGNjZvuO8QZr13SOH09gqjW4WPA=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [
    "pylibrespot_java"
  ];

  meta = {
    description = "Simple library to interface with a librespot-java server";
    homepage = "https://github.com/uvjustin/pylibrespot-java";
    changelog = "https://github.com/uvjustin/pylibrespot-java/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hensoko
    ];
  };
}
