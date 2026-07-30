{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pyyaml,
  pythonAtLeast,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.7.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    tag = "v${version}";
    hash = "sha256-ZRdwA3X1TCv0BIwr1gFeSi6UuziXiazciKw/6ewkpRE=";
  };

  build-system = [
    setuptools-scm
  ];

  optional-dependencies = {
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # regex mismatch
    "testMutuallyExclusiveArgs"
  ];

  pythonImportsCheck = [ "configargparse" ];

  meta = {
    description = "Drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    changelog = "https://github.com/bw2/ConfigArgParse/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
