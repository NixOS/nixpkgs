{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytedee-async";
  version = "0.2.17";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "pytedee_async";
    rev = "refs/tags/v${version}";
    hash = "sha256-5mCHCzoDJ6+ao2guhAtVjvPaAS6Hutn+NwaQIjWDlgo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
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
