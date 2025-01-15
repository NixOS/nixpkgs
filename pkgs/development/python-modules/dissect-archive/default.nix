{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-archive";
  version = "1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.archive";
    rev = "refs/tags/${version}";
    hash = "sha256-DUAJUbG3k6sbO7mqvNzQQns+4l8XHDUh0xZ/RA5LWEY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  pythonImportsCheck = [ "dissect.archive" ];

  meta = with lib; {
    description = "Dissect module implementing parsers for various archive and backup formats";
    homepage = "https://github.com/fox-it/dissect.archive";
    changelog = "https://github.com/fox-it/dissect.archive/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
