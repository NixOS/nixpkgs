{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  isal,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiohttp-isal";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohttp-isal";
    rev = "v${version}";
    hash = "sha256-rSXV5Z5JdznQGtRI83UIbaSfbIYkUHphJTVK/LM2V4U=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    isal
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  pythonImportsCheck = [ "aiohttp_isal" ];

  meta = with lib; {
    changelog = "https://github.com/bdraco/aiohttp-isal/blob/${src.rev}/CHANGELOG.md";
    description = "Isal support for aiohttp";
    homepage = "https://github.com/bdraco/aiohttp-isal";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
