{ composableDerivation, fetchurl, python }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} rec {

  flags =
  # python and ruby untested 
    edf { name = "python"; enable = { buildInputs = [ python ]; }; };
    # (if args.use_svn then ["libtool" "autoconf" "automake" "swig"] else [])
    # // edf { name = "ruby"; enable = { buildInputs = [ ruby ]; };}

  name = "geos-3.5.0";

  src = fetchurl {
    url = "http://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "49982b23bcfa64a53333dab136b82e25354edeb806e5a2e2f5b8aa98b1d0ae02";
  };

  enableParallelBuilding = true;

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
