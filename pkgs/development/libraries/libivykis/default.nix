{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, file, protobufc }:

stdenv.mkDerivation rec {
  pname = "libivykis";

  version = "0.43.1";

  src = fetchurl {
    url = "mirror://sourceforge/libivykis/${version}/ivykis-${version}.tar.gz";
    sha256 = "sha256-x9Kxi9k0Ln7f0T4OOKaNv+qm0x6S4+Z3K6o5Qp3+u58=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ file protobufc ];

  meta = with lib; {
    homepage = "https://libivykis.sourceforge.net/";
    description = ''
      A thin wrapper over various OS'es implementation of I/O readiness
      notification facilities
    '';
    license = licenses.zlib;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
