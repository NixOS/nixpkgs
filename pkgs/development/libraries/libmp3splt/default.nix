{ stdenv, fetchurl, libtool, libmad, libid3tag }:

stdenv.mkDerivation rec {
  name = "libmp3splt-0.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/mp3splt/${name}.tar.gz";
    sha256 = "1p1mn2hsmj5cp40fnc8g1yfvk72p8pjxi866gjdkgjsqrr7xdvih";
  };

  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ libtool ];
  buildInputs = [ libmad libid3tag ];

  configureFlags = [ "--disable-pcre" ];

  meta = with stdenv.lib; {
    homepage    = https://sourceforge.net/projects/mp3splt/;
    description = "Utility to split mp3, ogg vorbis and FLAC files without decoding";
    maintainers = with maintainers; [ bosu ];
    platforms   = platforms.unix;
  };
}
