{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioacaia";
  version = "0.1.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "aioacaia";
    tag = "v${version}";
    hash = "sha256-ltqY1n7Kvpf518q+cL8u+Cyg9BHySb0dopxKNtUdoA4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Module only has a homebrew tests
  doCheck = false;

  pythonImportsCheck = [ "aioacaia" ];

  meta = {
    description = "Async implementation of pyacaia";
    homepage = "https://github.com/zweckj/aioacaia";
    changelog = "https://github.com/zweckj/aioacaia/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
