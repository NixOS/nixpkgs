{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  eth-utils,
  hypothesis,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hexbytes";
  version = "1.2.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "hexbytes";
    rev = "refs/tags/v${version}";
    hash = "sha256-8st1nQiGApt+aNl8/cftYk0ZzA+MxbLyGi53UWUlAjM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    eth-utils
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hexbytes" ];

  meta = with lib; {
    description = "`bytes` subclass that decodes hex, with a readable console output";
    homepage = "https://github.com/ethereum/hexbytes";
    changelog = "https://github.com/ethereum/hexbytes/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
