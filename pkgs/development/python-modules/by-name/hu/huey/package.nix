{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  redis,
}:

buildPythonPackage (finalAttrs: {
  pname = "huey";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "huey";
    tag = finalAttrs.version;
    hash = "sha256-vXp8xISf8g1VjIus/Xr4wKFFaVg5x4CXgP8IUUKYl+o=";
  };

  build-system = [ setuptools ];

  dependencies = [ redis ];

  # connects to redis
  doCheck = false;

  pythonImportsCheck = [ "huey" ];

  meta = {
    description = "Module to queue tasks";
    homepage = "https://github.com/coleifer/huey";
    changelog = "https://github.com/coleifer/huey/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
