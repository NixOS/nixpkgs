{ stdenv, fetchurl
, IOKit ? null }:

stdenv.mkDerivation rec {
  name = "libstatgrab-0.92";

  src = fetchurl {
    url = "https://ftp.i-scream.org/pub/i-scream/libstatgrab/${name}.tar.gz";
    sha256 = "15m1sl990l85ijf8pnc6hdfha6fqyiq74mijrzm3xz4zzxm91wav";
  };

  buildInputs = [] ++ stdenv.lib.optional stdenv.isDarwin IOKit;

  meta = with stdenv.lib; {
    homepage = "https://www.i-scream.org/libstatgrab/";
    description = "A library that provides cross platforms access to statistics about the running system";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
