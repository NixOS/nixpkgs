{lib, stdenv, fetchurl, gtk2, aspell, pkg-config, enchant, intltool}:

stdenv.mkDerivation {
  name = "gtkspell-2.0.16";

  src = fetchurl {
    url = "mirror://sourceforge/gtkspell/gtkspell-2.0.16.tar.gz";
    sha256 = "00hdv28bp72kg1mq2jdz1sdw2b8mb9iclsp7jdqwpck705bdriwg";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [aspell gtk2 enchant intltool];

  meta = with lib; {
    description = "Word-processor-style highlighting and replacement of misspelled words";
    homepage = "http://gtkspell.sourceforge.net";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
