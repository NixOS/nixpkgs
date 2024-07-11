{ lib, stdenv, fetchurl, popt }:

stdenv.mkDerivation rec {
  pname = "libdv";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/libdv/libdv-${version}.tar.gz";
    sha256 = "1fl96f2xh2slkv1i1ix7kqk576a0ak1d33cylm0mbhm96d0761d3";
  };

  # Disable priority scheduling on Darwin because it doesn’t support sched_setscheduler.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace encodedv/dvconnect.c \
      --replace '#ifdef _SC_PRIORITY_SCHEDULING' '#if 0'
  '';

  configureFlags = [
    "--disable-asm"
    "--disable-sdl"
    "--disable-gtk"
    "--disable-xv"
    "--disable-gprof"
  ];

  buildInputs = [ popt ];

  meta = with lib; {
    description = "Software decoder for DV format video, as defined by the IEC 61834 and SMPTE 314M standards";
    homepage = "https://sourceforge.net/projects/libdv/";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
