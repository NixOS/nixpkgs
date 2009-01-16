args: with args;
let inherit (args.composableDerivation) composableDerivation edf; in
composableDerivation {

  initial = {

    buildInputs = [ "which" ]; # which is needed for the autogen.sh

    flags =
    # python and ruby untested 
      edf { name = "python"; enable = { buildInputs = [ python ]; }; };
      # (if args.use_svn then ["libtool" "autoconf" "automake" "swig"] else [])
      # // edf { name = "ruby"; enable = { buildInputs = [ ruby ]; };}

    name = "geos-3.0.3";

    src = fetchurl {
        url = http://download.osgeo.org/geos/geos-3.0.3.tar.bz2;
        sha256 = "1pxk20jcbyidp3bvip1vdf8wfw2wvh8pcn810qkf1y3zfnki0c7k";
    };

    # for development version. can be removed ?
    #configurePhase = "
    #  [ -f configure ] || \\
    #  LIBTOOLIZE=libtoolize ./autogen.sh
    #  [>{ automake --add-missing; autoconf; }
    #  unset configurePhase; configurePhase
    #";

    meta = {
        description = "C++ port of the Java Topology Suite (JTS)"
          + "- all the OpenGIS \"Simple Features for SQL\" spatial predicate functions and spatial operators,"
          + " as well as specific JTS topology functions such as IsValid";
        homepage = http://geos.refractions.net/;
        license = "GPL";
    };
  };
}
