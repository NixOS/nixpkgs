{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyecowitt";
  version = "0.21";
  pyproject = true;

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "Python module for the EcoWitt Protocol";
    homepage = "https://github.com/garbled1/pyecowitt";
    changelog = "https://github.com/garbled1/pyecowitt/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
