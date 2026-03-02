{
  lib,
  python3Packages,
  fetchPypi,
  taskwarrior2,
  glibcLocales,
}:

with python3Packages;

buildPythonApplication (finalAttrs: {
  pname = "vit";
  version = "2.3.3";
  pyproject = true;
  disabled = lib.versionOlder python.version "3.7";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+lrXGfhoB4z5IWkJTXMIm3GGVPfNGO9lUB3uFTx8hDY=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = [
    tasklib
    urwid
  ];

  nativeCheckInputs = [ glibcLocales ];

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    "${taskwarrior2}/bin"
  ];

  preCheck = ''
    export TERM=''${TERM-linux}
  '';

  pythonImportsCheck = [ "vit" ];

  meta = {
    homepage = "https://github.com/scottkosty/vit";
    description = "Visual Interactive Taskwarrior";
    mainProgram = "vit";
    maintainers = with lib.maintainers; [ arcnmx ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
})
