{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "coqpit";
  version = "0.0.17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FY3PYd8dY5HFKkhD6kBzPt0k1eFugdqsO3yIN4oDk3E=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

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
    homepage = "https://github.com/coqui-ai/coqpit";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
