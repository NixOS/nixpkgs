{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pyyaml,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.7.2.dev0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    tag = version;
    hash = "sha256-9Iwx7sJ4BBag9FxZ87A4b3wGVxSQv+eNIAtXewjau9Q=";
  };

  optional-dependencies = {
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # regex mismatch
    "testMutuallyExclusiveArgs"
  ];

  pythonImportsCheck = [ "configargparse" ];

  meta = with lib; {
    description = "Drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    changelog = "https://github.com/bw2/ConfigArgParse/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
