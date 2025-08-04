{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-utils,
  hypothesis,
  pytestCheckHook,
  pythonOlder,
  pydantic,
}:

buildPythonPackage rec {
  pname = "hexbytes";
  version = "1.3.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "hexbytes";
    tag = "v${version}";
    hash = "sha256-xYXxlyVGdsksxZJtSpz1V3pj4NL7IzX0gaQeCoiHr8g=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    eth-utils
    hypothesis
    pytestCheckHook
    pydantic
  ];

  disabledTests = [ "test_install_local_wheel" ];

  pythonImportsCheck = [ "hexbytes" ];

  meta = with lib; {
    description = "`bytes` subclass that decodes hex, with a readable console output";
    homepage = "https://github.com/ethereum/hexbytes";
    changelog = "https://github.com/ethereum/hexbytes/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
