{ composableDerivation, fetchurl, python }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} rec {

  flags =
  # python and ruby untested 
    edf { name = "python"; enable = { buildInputs = [ python ]; }; };
    # (if args.use_svn then ["libtool" "autoconf" "automake" "swig"] else [])
    # // edf { name = "ruby"; enable = { buildInputs = [ ruby ]; };}

  name = "geos-3.3.8";

  src = fetchurl {
    url = "http://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "0fshz8s9g610ycl4grrmcdcxb01aqpc6qac3x3jjik0vlz8x9v7b";
  };

  enableParallelBuilding = true;

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
