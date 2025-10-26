{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycync";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kinachi249";
    repo = "pycync";
    tag = "v${version}";
    hash = "sha256-PDCS+ucfO5RRvTshGGjxir3ez7L405k5tL5svMxZMsg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "pycync" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    cd tests
  '';

  meta = {
    changelog = "https://github.com/Kinachi249/pycync/releases/tag/${src.tag}";
    description = "Python API library for Cync smart devices";
    homepage = "https://github.com/Kinachi249/pycync";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
