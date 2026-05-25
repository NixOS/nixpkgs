{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "pywmspro";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mback2k";
    repo = "pywmspro";
    tag = version;
    hash = "sha256-vEuJPJrGJffnk7FogcOXEiYNnciAFkzgAeJkjWZWt4M=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ aiohttp ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "wmspro" ];

  meta = {
    description = "Python library for WMS WebControl pro API";
    homepage = "https://github.com/mback2k/pywmspro";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
