{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  filetype,
  gitpython,
  jinja2,
  jsonschema,
  markdown,
  packaging,
  pdiff,
  pillow,
  pre-commit,
  prompt-toolkit,
  pytest,
  pytest-workflow,
  pyyaml,
  questionary,
  requests,
  requests-cache,
  rich,
  rich-click,
  tabulate,
  trogon,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nf-core";
  version = "2.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nf-core";
    repo = "tools";
    rev = version;
    hash = "sha256-LuJm6/v/RFQ999U0LznzsMp3Hnxi3r5cl2iOZ2BtnKE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    filetype
    gitpython
    jinja2
    jsonschema
    markdown
    packaging
    pdiff
    pillow
    pre-commit
    prompt-toolkit
    pytest
    pytest-workflow
    pyyaml
    questionary
    requests
    requests-cache
    rich
    rich-click
    setuptools
    tabulate
    trogon
  ];

  # NOTE Not going to support as it would require packaging up 10+ additional
  # packages and is a niche feature nf-core plans on dropping support for
  pythonRemoveDeps = [ "refgenie" ];

  pythonImportsCheck = [ "nf_core" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python package with helper tools for the nf-core community";
    homepage = "https://nf-co.re/tools";
    changelog = "https://github.com/nf-core/tools/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edmundmiller ];
    mainProgram = "nf-core";
  };
}
