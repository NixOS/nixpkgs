{
  lib,
  fetchFromGitHub,
  python3Packages,
  ncurses,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "termtekst";
  version = "1.0";
  pyproject = true;

  build-system = with python3Packages; [ setuptools ];

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "termtekst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K3FPx63kg/Q1Npl8xhC9KIJgnDlLoH5P5cCoRFqRp74=";
  };

  dependencies = with python3Packages; [
    ncurses
    requests
  ];

  patchPhase = ''
    substituteInPlace setup.py \
      --replace-fail "assert" "assert 1==1 #"
    substituteInPlace src/tt \
      --replace-fail "locale.setlocale" "#locale.setlocale"
  '';

  meta = {
    description = "Console NOS Teletekst viewer in Python";
    mainProgram = "tt";
    longDescription = ''
      Small Python app using curses to display Dutch NOS Teletekst on
      the Linux console. The original Teletekst font includes 2x6
      raster graphics glyphs which have no representation in unicode;
      as a workaround the braille set is abused to approximate the
      graphics.
    '';
    homepage = "https://github.com/zevv/termtekst";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
