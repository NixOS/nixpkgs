{stdenv, fetchurl, gtk, aspell, pkgconfig, enchant, intltool}:

stdenv.mkDerivation {
  name = "gtkspell-2.0.16";
  
  src = fetchurl {
    url = mirror://sourceforge/gtkspell/gtkspell-2.0.16.tar.gz;
    sha256 = "00hdv28bp72kg1mq2jdz1sdw2b8mb9iclsp7jdqwpck705bdriwg";
  };
  
  buildInputs = [aspell pkgconfig gtk enchant intltool];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
