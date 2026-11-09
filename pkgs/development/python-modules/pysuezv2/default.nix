{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysuezv2";
  version = "2.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jb101010-2";
    repo = "pySuez";
    tag = finalAttrs.version;
    hash = "sha256-5+6vv6mZ7wEb2BX5fso8h8a7/wb376BJzJEGBlEBKaU=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysuez" ];

  meta = {
    description = "Module for dealing with water consumption data from Suez";
    homepage = "https://github.com/jb101010-2/pySuez";
    changelog = "https://github.com/jb101010-2/pySuez/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
