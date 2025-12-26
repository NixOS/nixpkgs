{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  beautifulsoup4,
  markdown,
  mkdocs,
  pandas,
  pyyaml,
  rich,
  super-collections,
}:

buildPythonPackage rec {
  pname = "mkdocs-test";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-test";
    tag = "v${version}";
    hash = "sha256-IP6qL+qR8uYSV5eG7/spiiNtdNghApdiuHBF+8OjPPg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    beautifulsoup4
    markdown
    mkdocs
    pandas
    pyyaml
    rich
    super-collections
  ];

  pythonImportsCheck = [
    "mkdocs_test"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mkdocs
  ]
  ++ pandas.optional-dependencies.html;

  meta = {
    changelog = "https://github.com/fralau/mkdocs-test/releases/tag/${src.tag}";
    description = "Framework for testing MkDocs projects";
    homepage = "https://github.com/fralau/mkdocs-test";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
