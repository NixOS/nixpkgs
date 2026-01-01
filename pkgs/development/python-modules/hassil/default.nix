{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pyyaml,
  unicode-rbnf,

  # tests
  pytestCheckHook,
}:

let
  pname = "hassil";
<<<<<<< HEAD
  version = "3.5.0";
=======
  version = "3.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "hassil";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ei4+eGNCzBZQYghgVuQIPgFA2Y1kf8aNtl6ZjwzxIEE=";
=======
    hash = "sha256-rroljEJ0xXW15iKmW6C64+h8epNB6XJzKtylA/wKyWQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    unicode-rbnf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # infinite recursion with home-assistant.intents
    "tests/test_fuzzy.py"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/home-assistant/hassil/blob/${src.tag}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    mainProgram = "hassil";
    homepage = "https://github.com/home-assistant/hassil";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
=======
    license = licenses.asl20;
    teams = [ teams.home-assistant ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
