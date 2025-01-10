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
  version = "2.3.2";
  disabled = lib.versionOlder python.version "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qDfY6GWnDQ44Sh540xQzDwANEI+mLjpy2a7G3sfKIzw=";
  };

  propagatedBuildInputs = [
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

  meta = with lib; {
    homepage = "https://github.com/scottkosty/vit";
    description = "Visual Interactive Taskwarrior";
    mainProgram = "vit";
    maintainers = with maintainers; [ arcnmx ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
