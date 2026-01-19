{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  coloraide,
  humanize,
  multimethod,
  platformdirs,
  rich,
  sqlparse,
  typing-extensions,
  rgbxy ? null,
}:
let
  version = "0.8.0";
in
buildPythonPackage {
  pname = "rich-tables";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    pname = "rich_tables";
    inherit version;
    hash = "sha256-MN8QH6kLyogbcQ0VE9U034cwSFnaFDB2/Rnvy1DYyl4=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    coloraide
    humanize
    multimethod
    platformdirs
    rich
    sqlparse
    typing-extensions
  ];

  optional-dependencies = {
    hue = [
      rgbxy
    ];
  };

  pythonRelaxDeps = [
    "multimethod"
  ];

  pythonImportsCheck = [
    "rich_tables"
  ];

  meta = {
    description = "Ready-made rich tables for various purposes";
    homepage = "https://pypi.org/project/rich-tables/";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "table";
  };
}
