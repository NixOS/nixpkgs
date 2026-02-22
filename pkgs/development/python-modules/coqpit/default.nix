{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pytestCheckHook,
  hatchling,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "coqpit-config";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "idiap";
    repo = "coqui-ai-coqpit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lverGecVRwhpdtX5463O6+CMJGye8VXj3JJZ+VhKcn8=";
  };

  build-system = [ hatchling ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "coqpit"
    "coqpit.coqpit"
  ];

  # https://github.com/coqui-ai/coqpit/issues/40
  disabledTests = lib.optionals (pythonAtLeast "3.11") [ "test_init_argparse_list_and_nested" ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.11") [ "tests/test_nested_configs.py" ];

  meta = {
    description = "Simple but maybe too simple config management through python data classes";
    longDescription = ''
      Simple, light-weight and no dependency config handling through python data classes with to/from JSON serialization/deserialization.
    '';
    homepage = "https://github.com/idiap/coqui-ai-coqpit";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
})
