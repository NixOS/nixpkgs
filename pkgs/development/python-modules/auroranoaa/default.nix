{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "auroranoaa";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

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

  meta = with lib; {
    description = "Python wrapper for the Aurora API";
    homepage = "https://github.com/djtimca/aurora-api";
    changelog = "https://github.com/djtimca/aurora-api/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
