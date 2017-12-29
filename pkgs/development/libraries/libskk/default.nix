{ stdenv, fetchurl, fetchFromGitHub,
  libtool, intltool, pkgconfig,
  vala, gnome_common, gobjectIntrospection,
  libgee_0_8, json_glib, skk-dicts }:

stdenv.mkDerivation rec {
  name = "libskk-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "ueno";
    repo = "libskk";
    rev = "6a232e75de6d5dbe543ab17c9b85dc7560093509";
    sha256 = "1xa9akf95jyi4laiw1llnjdpfq5skhidm7dnkd0i0ds6npzzqnxc";
  };

  buildInputs = [ skk-dicts ];
  nativeBuildInputs = [ vala gnome_common gobjectIntrospection libtool intltool pkgconfig ];
  propagatedBuildInputs = [ libgee_0_8 json_glib ];

  preConfigure = ''
    ./autogen.sh
  '';

  # link SKK-JISYO.L from skkdicts for the bundled tool `skk`
  preInstall = ''
    dictDir=$out/share/skk
    mkdir -p $dictDir
    ln -s ${skk-dicts}/share/SKK-JISYO.L $dictDir/
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A library to deal with Japanese kana-to-kanji conversion method";
    longDescription = ''
      Libskk is a library that implements basic features of SKK including:
      new word registration, completion, numeric conversion, abbrev mode, kuten input,
      hankaku-katakana input, Lisp expression evaluation (concat only), and re-conversion.
      It also supports various typing rules including: romaji-to-kana, AZIK, TUT-Code, and NICOLA,
      as well as various dictionary types including: file dictionary (such as SKK-JISYO.[SML]),
      user dictionary, skkserv, and CDB format dictionary.
    '';
    homepage = https://github.com/ueno/libskk;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ yuriaisaka ];
    platforms = stdenv.lib.platforms.linux;
  };
}
