{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "auroranoaa";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "aurora-api";
    tag = version;
    hash = "sha256-bQDFSbYFsGtvPuJNMykynOpBTIeloUoCVRtIuHXR4n0=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "auroranoaa" ];

  meta = {
    description = "Python wrapper for the Aurora API";
    homepage = "https://github.com/djtimca/aurora-api";
    changelog = "https://github.com/djtimca/aurora-api/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
