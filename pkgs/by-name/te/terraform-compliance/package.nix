{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "terraform-compliance";
  version = "1.3.52";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "terraform-compliance";
    repo = "cli";
    tag = version;
    hash = "sha256-M6u1P1UxOrP9bNPjPB0V15DUj+Y/1dFIjf/GCnYoCwc=";
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

  meta = with lib; {
    description = "BDD test framework for terraform";
    mainProgram = "terraform-compliance";
    homepage = "https://github.com/terraform-compliance/cli";
    changelog = "https://github.com/terraform-compliance/cli/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      kalbasit
      kashw2
    ];
  };
}
