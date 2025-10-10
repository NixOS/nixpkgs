{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrituals";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milanmeu";
    repo = "pyrituals";
    tag = version;
    hash = "sha256-nCyfwOONtpwRLFq3crRacmrWef6J3mOfKz4fvkOcb3g=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyrituals" ];

  meta = with lib; {
    description = "Python wrapper for the Rituals Perfume Genie API";
    homepage = "https://github.com/milanmeu/pyrituals";
    changelog = "https://github.com/milanmeu/pyrituals/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
