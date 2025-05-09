{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rctclient";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "svalouch";
    repo = "python-rctclient";
    rev = "refs/tags/v${version}";
    hash = "sha256-QPla5h8wSM9Ynj44Uwc1a2yAnu8TXbyBWzVHQeW6jnI=";
  };

  build-system = [ setuptools ];

  optional-dependencies.cli = [ click ];

  pythonImportsCheck = [ "rctclient" ];

  meta = with lib; {
    description = "Python implementation of the RCT Power GmbH Serial Communication Protocol";
    homepage = "https://github.com/svalouch/python-rctclient";
    changelog = "https://github.com/svalouch/python-rctclient/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ _9R ];
  };
}
