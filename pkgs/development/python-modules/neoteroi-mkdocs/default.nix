{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  click,
  essentials-openapi,
  flask,
  hatchling,
  httpx,
  jinja2,
  mkdocs,
  pytestCheckHook,
  pythonImportsCheckHook,
  rich,
  setuptools,
}:
buildPythonPackage rec {
  pname = "neoteroi-mkdocs";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "mkdocs-plugins";
    rev = "v${version}";
    hash = "sha256-UyTlgKWdBWckI9sBL4GRQtgNHYpHpZlWVOdmdQ+7lss=";
  };

  buildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    flask
    setuptools
  ];

  propagatedBuildInputs = [
    essentials-openapi
    click
    jinja2
    httpx
    mkdocs
    rich
  ];

  disabledTests = [
    "test_contribs" # checks against its own git repository
  ];

  pythonImportsCheck = [
    "neoteroi.mkdocs"
  ];

  meta = with lib; {
    homepage = "https://github.com/Neoteroi/mkdocs-plugins";
    description = "Plugins for MkDocs";
    changelog = "https://github.com/Neoteroi/mkdocs-plugins/releases/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [aldoborrero zimbatm];
  };
}
