{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  setuptools,
}:

buildPythonPackage rec {
  pname = "millheater";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pymill";
    tag = version;
    hash = "sha256-CDPk3AiLFNOovjNi4fDy91BBcxpbyFV9FCN1uU5bxbc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mill" ];

  meta = with lib; {
    description = "Python library for Mill heater devices";
    homepage = "https://github.com/Danielhiversen/pymill";
    changelog = "https://github.com/Danielhiversen/pymill/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
