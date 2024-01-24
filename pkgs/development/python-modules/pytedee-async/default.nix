{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pythonOlder
, aiohttp
}:

buildPythonPackage rec {
  pname = "pytedee-async";
  version = "0.2.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pytedee_async";
    rev = "refs/tags/v${version}";
    hash = "sha256-mBTY2JU79Hk6P+oWQ+2FD0BYHL1c865EvnTUl6H+gnk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonImportsCheck = [
    "pytedee_async"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Module to interact with Tedee locks";
    homepage = "https://github.com/zweckj/pytedee_async";
    changelog = "https://github.com/zweckj/pytedee_async/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
