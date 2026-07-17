{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  pyyaml,
  tqdm,
  pytestCheckHook,
  pytest-mock,
}:
let
  version = "2.3.2";
in
buildPythonPackage {
  pname = "docstr-coverage";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "HunterMcGushion";
    repo = "docstr_coverage";
    tag = "v${version}";
    hash = "sha256-k1ny4fWS+CmgLNWPlYPsscjei2UZ6h8QJrZSay5abck=";
  };

  propagatedBuildInputs = [
    click
    pyyaml
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # AssertionError: assert 'docstr_coverage' in '/build/source/tests'
    "test_set_config_defaults_with_ignore_patterns"
    # click 8.3 no longer overwrites ctx.params entries set by callbacks, so config-file
    # paths silently win over CLI paths in these parametrize cases
    "config_specifier_w_ignore"
  ];

  meta = {
    description = "Docstring coverage analysis and rating for Python";
    mainProgram = "docstr-coverage";
    homepage = "https://github.com/HunterMcGushion/docstr_coverage";
    changelog = "https://github.com/HunterMcGushion/docstr_coverage/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ augustebaum ];
  };
}
