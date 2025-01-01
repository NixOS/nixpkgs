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
  version = "0.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "idiap";
    repo = "coqui-ai-coqpit";
    rev = "refs/tags/v${version}";
    hash = "sha256-3LZxoj2aFTpezakBymogkNPCaEBBaaUmyIa742cSMgU=";
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
