{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  beautifulsoup4,
  html5lib,
  lxml,
  markdown,
  pyyaml,
  soupsieve,
  wcmatch,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyspelling";
  version = "2.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kQiYHcF01kAKftSRfPSvkdrz64NXjUVwwHJrksKjLno=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
    html5lib
    lxml
    markdown
    pyyaml
    soupsieve
    wcmatch
  ];

  pythonImportsCheck = [
    "pyspelling"
  ];

  meta = {
    changelog = "https://github.com/facelessuser/pyspelling/blob/${finalAttrs.version}/docs/src/markdown/about/changelog.md";
    description = "Spell checker";
    homepage = "https://pypi.org/project/pyspelling";
    license = lib.licenses.mit;
    mainProgram = "pyspelling";
    maintainers = [ ];
  };
})
