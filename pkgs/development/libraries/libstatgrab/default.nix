{ lib
, stdenv
, fetchurl
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "libstatgrab";
  version = "0.92";

  src = fetchurl {
    url = "https://ftp.i-scream.org/pub/i-scream/libstatgrab/${pname}-${version}.tar.gz";
    sha256 = "15m1sl990l85ijf8pnc6hdfha6fqyiq74mijrzm3xz4zzxm91wav";
  };

  buildInputs = lib.optional stdenv.isDarwin IOKit;

  meta = with lib; {
    homepage = "https://www.i-scream.org/libstatgrab/";
    description = "A library that provides cross platforms access to statistics about the running system";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
