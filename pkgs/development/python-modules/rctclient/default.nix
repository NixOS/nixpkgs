{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rctclient";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "svalouch";
    repo = "python-rctclient";
    tag = "v${version}";
    hash = "sha256-QPla5h8wSM9Ynj44Uwc1a2yAnu8TXbyBWzVHQeW6jnI=";
  };

  build-system = [ setuptools ];

  optional-dependencies.cli = [ click ];

  pythonImportsCheck = [ "rctclient" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python implementation of the RCT Power GmbH Serial Communication Protocol";
    homepage = "https://github.com/svalouch/python-rctclient";
    changelog = "https://github.com/svalouch/python-rctclient/releases/tag/${src.tag}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ _9R ];
  };
}
