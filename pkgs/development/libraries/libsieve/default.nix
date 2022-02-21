{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  version = "2.3.1";
  pname = "libsieve";

  src = fetchurl {
    url = "https://github.com/downloads/sodabrew/libsieve/libsieve-${version}.tar.gz";
    sha256 = "1gllhl9hbmc86dq3k98d4kjs5bwk0p2rlk7ywqj3fjn7jw6mbhcj";
  };

  meta = with lib; {
    description = "An interpreter for RFC 3028 Sieve and various extensions";
    homepage = "http://sodabrew.com/libsieve/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
