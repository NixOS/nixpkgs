{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-git,
  click,
  jinja2,
  lxml,
  tabulate,
  ruamel-yaml,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "pycobertura";
  version = "4.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aconrad";
    repo = "pycobertura";
    tag = "v${version}";
    hash = "sha256-OzOxoF3OmgtzWuNNyecyxFRcPq8gAPQZ2XAdrkJjnhk=";
  };

  postPatch = ''
    # Remove build-system requirements as we handle them through Nix
    sed -i '/\[build-system\]/,/build-backend/d' pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-git
  ];

  dependencies = [
    click
    jinja2
    lxml
    tabulate
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  disabledTests = [
    # Tests require git and a git repository
    "test_filesystem_git_integration"
    "test_filesystem_git_integration__not_found"
    "test_filesystem_git_has_file_integration"
    "test_filesystem_git_has_file_integration__not_found"
    "test_filesystem_factory"
  ];

  pythonImportsCheck = [ "pycobertura" ];

  meta = {
    description = "Cobertura coverage parser that can diff reports and show coverage progress";
    homepage = "https://github.com/aconrad/pycobertura";
    changelog = "https://github.com/aconrad/pycobertura/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
    mainProgram = "pycobertura";
  };
}
