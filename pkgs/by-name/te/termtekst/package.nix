{
  lib,
  fetchFromGitHub,
  python3Packages,
  ncurses,
}:

python3Packages.buildPythonApplication rec {
  pname = "termtekst";
  version = "1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "termtekst";
    rev = "v${version}";
    sha256 = "1gm7j5d49a60wm7px82b76f610i8pl8ccz4r6qsz90z4mp3lyw9b";
  };

  propagatedBuildInputs = with python3Packages; [
    ncurses
    requests
  ];

  patchPhase = ''
    substituteInPlace setup.py \
      --replace "assert" "assert 1==1 #"
    substituteInPlace src/tt \
      --replace "locale.setlocale" "#locale.setlocale"
  '';

  meta = with lib; {
    description = "Console NOS Teletekst viewer in Python";
    mainProgram = "tt";
    longDescription = ''
      Small Python app using curses to display Dutch NOS Teletekst on
      the Linux console. The original Teletekst font includes 2x6
      raster graphics glyphs which have no representation in unicode;
      as a workaround the braille set is abused to approximate the
      graphics.
    '';
    license = licenses.mit;
    platforms = platforms.all;
  };
}
