{ composableDerivation, fetchurl, python }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} rec {

  flags =
  # python and ruby untested 
    edf { name = "python"; enable = { buildInputs = [ python ]; }; };
    # (if args.use_svn then ["libtool" "autoconf" "automake" "swig"] else [])
    # // edf { name = "ruby"; enable = { buildInputs = [ ruby ]; };}

  name = "geos-3.4.2";

  src = fetchurl {
    url = "http://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "0lvcs8x9as5jlxilykgg3i4220x8m4z59b2ngfapl219gvgvzs0m";
  };

  enableParallelBuilding = true;

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
