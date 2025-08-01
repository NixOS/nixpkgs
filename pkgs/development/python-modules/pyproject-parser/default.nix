{
  buildPythonPackage,
  fetchPypi,
  lib,
  apeye-core,
  attrs,
  click,
  consolekit,
  docutils,
  dom-toml,
  domdf-python-tools,
  hatchling,
  hatch-requirements-txt,
  natsort,
  packaging,
  readme-renderer,
  sdjson,
  shippinglabel,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "pyproject-parser";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pyproject_parser";
    inherit version;
    hash = "sha256-/x3bXUJsbYs4rXPNotXK8/VohSy04M+Gk0XInoyg+3Y=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [
    apeye-core
    attrs
    dom-toml
    domdf-python-tools
    natsort
    packaging
    shippinglabel
    typing-extensions
  ];

  optional-dependencies = {
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") optional-dependencies));
    cli = [
      click
      consolekit
      sdjson
    ];
    readme = [
      docutils
      readme-renderer
    ]
    ++ readme-renderer.optional-dependencies.md;
  };

  meta = {
    description = "Parser for ‘pyproject.toml’";
    homepage = "https://github.com/repo-helper/pyproject-parser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
