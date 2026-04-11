{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "terraform-compliance";
  version = "1.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "terraform-compliance";
    repo = "cli";
    tag = finalAttrs.version;
    hash = "sha256-wWwYM1ZCHiBdbjl5kRI9dFSWp7mpYb/2HlV7lbU/Xeg=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  pythonRelaxDeps = [
    "radish-bdd"
    "IPython"
  ];

  dependencies = with python3.pkgs; [
    diskcache
    emoji
    filetype
    gitpython
    ipython
    junit-xml
    lxml
    mock
    netaddr
    radish-bdd
    semver
    orjson
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    "test_which_success"
    "test_readable_plan_file_is_not_json"
  ];

  pythonImportsCheck = [
    "terraform_compliance"
  ];

  meta = {
    description = "BDD test framework for terraform";
    mainProgram = "terraform-compliance";
    homepage = "https://github.com/terraform-compliance/cli";
    changelog = "https://github.com/terraform-compliance/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      kashw2
    ];
  };
})
