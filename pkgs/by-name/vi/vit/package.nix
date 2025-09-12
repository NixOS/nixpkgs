{
  lib,
  python3Packages,
  fetchPypi,
  taskwarrior2,
  glibcLocales,
}:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.3.3";
  pyproject = true;
  disabled = lib.versionOlder python.version "3.7";

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    homepage = "https://github.com/scottkosty/vit";
    description = "Visual Interactive Taskwarrior";
    mainProgram = "vit";
    maintainers = with maintainers; [ arcnmx ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
