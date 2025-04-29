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
  rich,
  setuptools,
}:
buildPythonPackage rec {
  pname = "neoteroi-mkdocs";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Neoteroi";
    repo = "mkdocs-plugins";
    tag = "v${version}";
    hash = "sha256-EbhkhcH8sGxiwimg9dfmSSOJR7DYw7nfS3m1HUSH0vg=";
  };

  buildInputs = [ hatchling ];

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

  pythonImportsCheck = [ "neoteroi.mkdocs" ];

  meta = with lib; {
    homepage = "https://github.com/Neoteroi/mkdocs-plugins";
    description = "Plugins for MkDocs";
    changelog = "https://github.com/Neoteroi/mkdocs-plugins/releases/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      aldoborrero
      zimbatm
    ];
  };
}
