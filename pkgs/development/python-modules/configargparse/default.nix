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
  version = "1.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    tag = version;
    hash = "sha256-m77MY0IZ1AJkd4/Y7ltApvdF9y17Lgn92WZPYTCU9tA=";
  };

  patches = [
    # https://github.com/bw2/ConfigArgParse/pull/295
    ./python3.13-compat.patch
  ];

  optional-dependencies = {
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # regex mismatch
    "testMutuallyExclusiveArgs"
  ];

  pythonImportsCheck = [ "configargparse" ];

  meta = with lib; {
    description = "Drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    changelog = "https://github.com/bw2/ConfigArgParse/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
