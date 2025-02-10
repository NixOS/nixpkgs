{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pytestCheckHook,
  hatchling,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "coqpit-config";
  version = "0.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "idiap";
    repo = "coqui-ai-coqpit";
    tag = "v${version}";
    hash = "sha256-iitAq+sOPFQqKiwwnPnWheZ+0+OLznu3G9Ncf18s4VQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "coqpit"
    "coqpit.coqpit"
  ];

  # https://github.com/coqui-ai/coqpit/issues/40
  disabledTests = lib.optionals (pythonAtLeast "3.11") [ "test_init_argparse_list_and_nested" ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.11") [ "tests/test_nested_configs.py" ];

  meta = with lib; {
    description = "Simple but maybe too simple config management through python data classes";
    longDescription = ''
      Simple, light-weight and no dependency config handling through python data classes with to/from JSON serialization/deserialization.
    '';
    homepage = "https://github.com/idiap/coqui-ai-coqpit";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
