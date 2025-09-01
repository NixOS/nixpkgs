{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libtirpc,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "teapot";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "teapot";
    tag = finalAttrs.version;
    hash = "sha256-38XFjRzOGasr030f+mRYT+ptlabpnVJfa+1s7ZAjS+k=";
  };

  prePatch = ''
    cd src
  '';

  patches = [
    # include a local file in order to make cc happy
    ./001-fix-warning.patch
    # remove the ENABLE_HELP target entirely - lyx and latex are huge!
    ./002-remove-help.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libtirpc
    ncurses
  ];

  # By no known reason libtirpc is not detected
  env.NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-ltirpc" ];

  cmakeConfigureFlags = [
    "-DENABLE_HELP=OFF"
  ];

  meta = {
    description = "Table Editor And Planner, Or: Teapot";
    longDescription = ''
      Teapot is a compact spreadsheet software originally written by Michael
      Haardt. It features a (n)curses-based text terminal interface, and
      recently also a FLTK-based GUI.

      These days, it may seem pointless having yet another spreadsheet program
      (and one that doesn't even know how to load Microsoft Excel files). Its
      compact size (130k for the ncurses executable, 140k for the GUI
      executable, 300k for the self-contained Windows EXE) and the fact that it
      can run across serial lines and SSH sessions make it an interesting choice
      for embedded applications and as system administration utility, even more
      so since it has a batch processing mode and comes with example code for
      creating graphs from data sets.

      Another interesting feature is its modern approach to spread sheet theory:
      It sports true three-dimensional tables and iterative expressions. And
      since it breaks compatibility with the usual notions of big spreadsheet
      packages, it can also throw old syntactic cruft over board which many
      spreadsheets still inherit from the days of VisiCalc on ancient CP/M
      systems.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "teapot";
    homepage = "https://github.com/museoa/teapot";
    changelog = "https://github.com/museoa/teapot/releases/tag/${finalAttrs.version}";
  };
})
# TODO: patch/fix FLTK building
# TODO: add documentation
