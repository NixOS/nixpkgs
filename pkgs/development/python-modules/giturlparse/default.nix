{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "giturlparse";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nephila";
    repo = "giturlparse";
    tag = finalAttrs.version;
    hash = "sha256-EzybKpff9u4axubSbFR/knSVYtOoz7Ls9rAjMohWP8k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "giturlparse" ];

  meta = {
    description = "Parse & rewrite git urls (supports GitHub, Bitbucket, Assembla ...)";
    homepage = "https://github.com/nephila/giturlparse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yajo ];
  };
})
