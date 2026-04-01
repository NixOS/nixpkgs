{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ohme";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dan-r";
    repo = "ohmepy";
    tag = "v${version}";
    hash = "sha256-A+cGgM3pkOv1b3/+3XiqdhLo2JJbSNruZKbNG2o9BaE=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "ohme" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module for interacting with the Ohme API";
    homepage = "https://github.com/dan-r/ohmepy";
    changelog = "https://github.com/dan-r/ohmepy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
