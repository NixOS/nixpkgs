{stdenv, fetchurl, libtool, libmad }:

stdenv.mkDerivation rec {
  name = "libmp3splt-0.9.1";
  
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/mp3splt/${name}.tar.gz";
    sha256 = "17ar9d669cnirkz1kdrim687wzi36y8inapnj4svlsvr00vdzfxa";
  };

  buildInputs = [ libtool libmad ];

  configureFlags = "--disable-pcre";

  meta = with stdenv.lib; {
    homepage    = http://sourceforge.net/projects/mp3splt/;
    description = "utility to split mp3, ogg vorbis and FLAC files without decoding";
    maintainers = with maintainers; [ bosu ];
    platforms   = platforms.unix;
  };
}
