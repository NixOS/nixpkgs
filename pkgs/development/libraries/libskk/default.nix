{ lib, stdenv, fetchFromGitHub,
  libtool, gettext, pkg-config,
  vala, gnome-common, gobject-introspection,
  libgee, json-glib, skkDictionaries, libxkbcommon }:

stdenv.mkDerivation rec {
  pname = "libskk";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ueno";
    repo = "libskk";
    rev = version;
    sha256 = "0y279pcgs3jrsi9vzx086xhz9jbz23dqqijp4agygc9ackp9sxy5";
  };

  buildInputs = [ libxkbcommon ];
  nativeBuildInputs = [ vala gnome-common gobject-introspection libtool gettext pkg-config ];
  propagatedBuildInputs = [ libgee json-glib ];

  preConfigure = ''
    ./autogen.sh
  '';

  # link SKK-JISYO.L from skkdicts for the bundled tool `skk`
  preInstall = ''
    dictDir=$out/share/skk
    mkdir -p $dictDir
    ln -s ${skkDictionaries.l}/share/skk/SKK-JISYO.L $dictDir/
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Library to deal with Japanese kana-to-kanji conversion method";
    mainProgram = "skk";
    longDescription = ''
      Libskk is a library that implements basic features of SKK including:
      new word registration, completion, numeric conversion, abbrev mode, kuten input,
      hankaku-katakana input, Lisp expression evaluation (concat only), and re-conversion.
      It also supports various typing rules including: romaji-to-kana, AZIK, TUT-Code, and NICOLA,
      as well as various dictionary types including: file dictionary (such as SKK-JISYO.[SML]),
      user dictionary, skkserv, and CDB format dictionary.
    '';
    homepage = "https://github.com/ueno/libskk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yuriaisaka ];
    platforms = lib.platforms.linux;
  };
}
