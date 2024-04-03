{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pythonOlder
, aiohttp
}:

buildPythonPackage rec {
  pname = "romy";
  version = "0.0.9";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "xeniter";
    repo = "romy";
    rev = "refs/tags/${version}";
    hash = "sha256-r7g8DE8eBFHkMHzGfNlYi+XxrRIvH8IDxGOSEiJKKqM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "romy"
  ];

  meta = with lib; {
    description = "Library to control Wi-Fi enabled ROMY vacuum cleaners";
    homepage = "https://github.com/xeniter/romy";
    changelog = "https://github.com/xeniter/romy/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
