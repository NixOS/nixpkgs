{ stdenv
, fetchurl
, symlinkJoin
, makeWrapper
, tcl
, fontconfig
, tk
, ncurses
, xorg
, file
}:

let
  # eli derives the location of the include folder from the location of the lib folder
  tk_combined = symlinkJoin {
    name = "tk_combined";
    paths = [
      tk
      tk.dev
    ];
  };
  curses_combined = symlinkJoin {
    name = "curses_combined";
    paths = [
      ncurses
      ncurses.dev
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "eli";
  version = "4.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/eli-project/Eli/Eli%20${version}/${pname}-${version}.tar.bz2";
    sha256="1vran8583hbwrr5dciji4zkhz3f88w4mn8n9sdpr6zw0plpf1whj";
  };

  buildInputs = [
    ncurses
    fontconfig
  ] ++ (with xorg; [
    libX11.dev
    libXt.dev
    libXaw.dev
    libXext.dev
  ]);

  nativeBuildInputs = [
    file
    makeWrapper
  ];

  # skip interactive browser check
  buildFlags = [ "nobrowsers" ];


  preConfigure=''
    configureFlagsArray=(
      --with-tcltk="${tcl} ${tk_combined}"
      --with-curses="${curses_combined}"
    )
    export ODIN_LOCALIPC=1
  '';

  postInstall = ''
    wrapProgram "$out/bin/eli" \
      --set ODIN_LOCALIPC 1
  '';

  # Test if eli starts
  doInstallCheck = true;
  installCheckPhase = ''
    export HOME="$TMP/home"
    mkdir -p "$HOME"
    $out/bin/eli "!ls"
  '';

  meta = {
    description = "Translator Construction Made Easy";
    longDescription = ''
      Eli is a programming environment that supports all phases of translator
      construction with extensive libraries implementing common tasks, yet handling
      arbitrary special cases. Output is the C subset of C++.
    '';
    homepage = http://eli-project.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ timokau ];
    platforms = stdenv.lib.platforms.linux;
  };
}
