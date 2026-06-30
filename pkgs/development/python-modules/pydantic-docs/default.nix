{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  click,
  markdown,
  mkdocs,
  mkdocs-material,
  pymdown-extensions,
  ruamel-yaml,
}:

buildPythonPackage {
  pname = "pydantic-docs";
  version = "unstable-2026-01-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-docs";
    rev = "6a53b295cad781f92a8485d7217964b571426269";
    hash = "sha256-mEjsZVBuPXR7gvzw9h/3v7/SvuZQnT7uiAtTAX859S8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    markdown
    mkdocs
    mkdocs-material
    pymdown-extensions
    ruamel-yaml
  ];

  pythonImportsCheck = [ "pydantic_docs.mdext" ];

  meta = {
    description = "Common infrastructure to build documentation for the Pydantic projects";
    homepage = "https://github.com/pydantic/pydantic-docs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
