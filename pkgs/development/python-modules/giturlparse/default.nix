{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  unittestCheckHook,
}:
buildPythonPackage rec {
  pname = "giturlparse";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nephila";
    repo = "giturlparse";
    tag = version;
    hash = "sha256-KBJVsg3xpy4WkXlkP+eNTJpGIpZhPI4TwD5/0eCbTL0=";
  };

  build-system = [
    setuptools
  ];
  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "giturlparse" ];

  meta = {
    description = "Parse & rewrite git urls (supports GitHub, Bitbucket, Assembla ...)";
    homepage = "https://github.com/nephila/giturlparse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
