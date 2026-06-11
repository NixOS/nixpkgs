{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cfgv";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "cfgv";
    tag = "v${version}";
    hash = "sha256-ccCalTNVEHvh1gKhQgceD/yAScIEQy3ZKqndoWs7FQQ=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cfgv" ];

  meta = {
    description = "Validate configuration and produce human readable error messages";
    homepage = "https://github.com/asottile/cfgv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
