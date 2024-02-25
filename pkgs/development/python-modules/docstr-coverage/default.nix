{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, pyyaml
, tqdm
, pytestCheckHook
, pytest-mock
}:
let
  version = "2.3.0";
in
buildPythonPackage {
  pname = "docstr-coverage";
  inherit version;

  src = fetchFromGitHub {
    owner = "HunterMcGushion";
    repo = "docstr_coverage";
    rev = "v${version}";
    hash = "sha256-eYHhE5zs3hYzK3aAimF0Gx/Kyk1Ot1F/lKf1poR2er0=";
  };

  propagatedBuildInputs = [ click pyyaml tqdm ];

  nativeCheckInputs = [ pytestCheckHook pytest-mock ];

  disabledTests = [
    # AssertionError: assert 'docstr_coverage' in '/build/source/tests'
    "test_set_config_defaults_with_ignore_patterns"
  ];

  meta = with lib; {
    description = "Docstring coverage analysis and rating for Python";
    homepage = "https://github.com/HunterMcGushion/docstr_coverage";
    changelog = "https://github.com/HunterMcGushion/docstr_coverage/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ augustebaum ];
  };
}
