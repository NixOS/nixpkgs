{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pydroplet";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hydrific";
    repo = "pydroplet";
    tag = "v${version}";
    hash = "sha256-4DZN4uFKmYpE2A+Hmy7mkJjhqNGRrZO6JJ5P+vnagHY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pydroplet" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/Hydrific/pydroplet/releases/tag/${src.tag}";
    description = "Package to connect to a Droplet device";
    homepage = "https://github.com/Hydrific/pydroplet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
