{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  coloraide,
  humanize,
  multimethod,
  platformdirs,
  rich,
  sqlparse,
  typing-extensions,

  # passthru
  rgbxy ? null,
}:
buildPythonPackage (finalAttrs: {
  pname = "rich-tables";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "rich_tables";
    inherit (finalAttrs) version;
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
})
