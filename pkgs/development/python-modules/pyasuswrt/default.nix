{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pyasuswrt";
  version = "0.1.20";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ollo69";
    repo = "pyasuswrt";
    rev = "refs/tags/v${version}";
    hash = "sha256-QsqyijOYEtp6k2rsDheGMVij4s5a5ZfUfsLIq+BaYV8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Tests require physical hardware
  doCheck = false;

  pythonImportsCheck = [
    "pyasuswrt"
  ];

  meta = with lib; {
    description = "Library for communication with ASUSWRT routers via HTTP";
    homepage = "https://github.com/ollo69/pyasuswrt";
    changelog = "https://github.com/ollo69/pyasuswrt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
