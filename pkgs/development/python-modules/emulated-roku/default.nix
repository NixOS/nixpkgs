{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "emulated-roku";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mindigmarton";
    repo = "emulated_roku";
    tag = version;
    hash = "sha256-lPe0mXtl1IQx//IydnmddpV11CpOi/MKq9TUOAKuoeU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "emulated_roku" ];

  meta = {
    changelog = "https://github.com/martonperei/emulated_roku/releases/tag/${src.tag}";
    description = "Library to emulate a roku server to serve as a proxy for remotes such as Harmony";
    homepage = "https://github.com/mindigmarton/emulated_roku";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
