{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyprusalink";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wwH4LE8wi8eb7QwT7N1mNtVleoWscDEOu2vrXKDktwU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "pyprusalink"
  ];

  meta = with lib; {
    description = "Library to communicate with PrusaLink ";
    homepage = "https://github.com/home-assistant-libs/pyprusalink";
    changelog = "https://github.com/home-assistant-libs/pyprusalink/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
