{
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ourgroceries";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ljmerza";
    repo = "py-our-groceries";
    tag = version;
    hash = "sha256-tlgctQvbR2YzM6Q1A/P1i40LSt4/2hsetlDeO07RBPE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    beautifulsoup4
  ];

  pythonImportsCheck = [ "ourgroceries" ];

  # tests require credentials
  doCheck = false;

  meta = {
    changelog = "https://github.com/ljmerza/py-our-groceries/releases/tag/${src.tag}";
    description = "Unofficial Python Wrapper for Our Groceries";
    homepage = "https://github.com/ljmerza/py-our-groceries";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
