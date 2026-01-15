{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyecowitt";
  version = "0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "garbled1";
    repo = "pyecowitt";
    tag = version;
    hash = "sha256-5VdVo6j2HZXSCWU4NvfWzyS/KJfVb7N1KSMeu8TvWaQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project thas no tests
  doCheck = false;

  pythonImportsCheck = [ "pyecowitt" ];

  meta = {
    description = "Python module for the EcoWitt Protocol";
    homepage = "https://github.com/garbled1/pyecowitt";
    changelog = "https://github.com/garbled1/pyecowitt/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
