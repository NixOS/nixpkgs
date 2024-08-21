{ lib
, stdenv
, fetchurl
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "libstatgrab";
  version = "0.92.1";

  src = fetchurl {
    url = "https://ftp.i-scream.org/pub/i-scream/libstatgrab/${pname}-${version}.tar.gz";
    sha256 = "sha256-VoiqSmhVR9cXSoo3PqnY7pJ+dm48wwK97jRSPCxdbBE=";
  };

  buildInputs = lib.optional stdenv.isDarwin IOKit;

  meta = with lib; {
    homepage = "https://www.i-scream.org/libstatgrab/";
    description = "Library that provides cross platforms access to statistics about the running system";
    maintainers = [ ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
