{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyserial,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "momonga";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbtk";
    repo = "momonga";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Ngm30Bo6hKeLLAOMyYxcgfiwOIessi5S0BB92Ye/rM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
  ];

  pythonImportsCheck = [ "momonga" ];

  # tests require access to the API
  doCheck = false;

  meta = {
    changelog = "https://github.com/nbtk/momonga/releases/tag/${finalAttrs.src.tag}";
    description = "Python Route B Library: A Communicator for Low-voltage Smart Electric Energy Meters";
    homepage = "https://github.com/nbtk/momonga";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
