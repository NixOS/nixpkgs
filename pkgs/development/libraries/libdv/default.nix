{ composableDerivation, fetchurl }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {

  flags = { }
    # TODO! implement flags
    # I want to get kino and cinelerra working. That's why I don't spend more time on this now
    // edf { name = "libtool_lock"; } #avoid locking (might break parallel builds)
    // edf { name ="asm"; } #disable use of architecture specific assembly code
    // edf { name ="sdl"; } #enable use of SDL for display
    // edf { name ="gtk"; } #disable use of gtk for display
    // edf { name ="xv"; } #disable use of XVideo extension for display
    // edf { name ="gprof"; }; #enable compiler options for gprof profiling

  name = "libdv-1.0.0";

  src = fetchurl {
    url = mirror://sourceforge/libdv/libdv-1.0.0.tar.gz;
    sha256 = "1fl96f2xh2slkv1i1ix7kqk576a0ak1d33cylm0mbhm96d0761d3";
  };

  meta = {
    description = "Software decoder for DV format video, as defined by the IEC 61834 and SMPTE 314M standards";
    homepage = http://sourceforge.net/projects/libdv/;
  };
}
