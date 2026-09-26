{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pyyaml,
  pythonAtLeast,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "configargparse";
  version = "1.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s1QkHTU36Kj+XK8dNiEXAxZrW2oDPISai056V+B4eog=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # regex mismatch
    "testMutuallyExclusiveArgs"
  ];

  pythonImportsCheck = [ "configargparse" ];

  meta = {
    description = "Drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    changelog = "https://github.com/bw2/ConfigArgParse/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
