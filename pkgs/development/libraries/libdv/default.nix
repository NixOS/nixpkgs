{ lib, stdenv, fetchurl, popt }:

stdenv.mkDerivation rec {
  pname = "libdv";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/libdv/libdv-${version}.tar.gz";
    sha256 = "1fl96f2xh2slkv1i1ix7kqk576a0ak1d33cylm0mbhm96d0761d3";
  };

  # This fixes an undefined symbol: _sched_setscheduler error on compile.
  # See the apple docs: http://cl.ly/2HeF bottom of the "Finding Imported Symbols" section
  LDFLAGS = lib.optionalString stdenv.isDarwin "-undefined dynamic_lookup";

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
