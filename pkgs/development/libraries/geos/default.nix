{ composableDerivation, fetchurl, python }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {

  flags =
  # python and ruby untested 
    edf { name = "python"; enable = { buildInputs = [ python ]; }; };
    # (if args.use_svn then ["libtool" "autoconf" "automake" "swig"] else [])
    # // edf { name = "ruby"; enable = { buildInputs = [ ruby ]; };}

  name = "geos-3.2.2";

  src = fetchurl {
    url = http://download.osgeo.org/geos/geos-3.2.2.tar.bz2;
    sha256 = "0711wcq46h7zgvp0bk4m60vmx1wal9db1q36mayf0vwk34hprpr4";
  };

  # for development version. can be removed ?
  #configurePhase = "
  #  [ -f configure ] || \\
  #  LIBTOOLIZE=libtoolize ./autogen.sh
  #  [>{ automake --add-missing; autoconf; }
  #  unset configurePhase; configurePhase
  #";

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
