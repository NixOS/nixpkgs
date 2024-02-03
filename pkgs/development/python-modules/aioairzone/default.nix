{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aioairzone";
  version = "0.6.9";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0nbH0pnTYRuSOkzG5Yn/fJmRKtXBMd6ti6Z+AW72j3Q=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioairzone"
  ];

  meta = with lib; {
    description = "Module to control AirZone devices";
    homepage = "https://github.com/Noltari/aioairzone";
    changelog = "https://github.com/Noltari/aioairzone/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

