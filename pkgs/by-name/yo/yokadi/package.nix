{
  lib,
  python3Packages,
  fetchurl,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "yokadi";
  version = "1.3.0";
  pyproject = true;

  src = fetchurl {
    url = "https://yokadi.github.io/download/yokadi-${finalAttrs.version}.tar.gz";
    hash = "sha256-zF2ffHeU+i7wzu1u4DhQ5zJXr8AjXboiyFAisXNX6TM=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    python-dateutil
    sqlalchemy
    setproctitle
    icalendar
    colorama
  ];

  pythonRelaxDeps = [
    "python-dateutil"
  ];

  # Yokadi doesn't have any tests
  doCheck = false;

  meta = {
    description = "Command line oriented, sqlite powered, todo-list";
    homepage = "https://yokadi.github.io/index.html";
    mainProgram = "yokadi";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.nkpvk ];
  };
})
