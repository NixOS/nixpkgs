{
  lib,
  aiofiles,
  aiohttp,
  backoff,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyprosegur";
  version = "0.0.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dgomes";
    repo = "pyprosegur";
    tag = version;
    hash = "sha256-FMkz5zZ5+607gfmw4KRmCgfR+TJF2JGLRVEUzZAjTrc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    backoff
    click
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyprosegur" ];

  meta = with lib; {
    description = "Python module to communicate with Prosegur Residential Alarms";
    homepage = "https://github.com/dgomes/pyprosegur";
    changelog = "https://github.com/dgomes/pyprosegur/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pyprosegur";
  };
}
