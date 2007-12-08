args:
( args.mkDerivationByConfiguration {

    flagConfig = {
      mandatory = { implies = "python"; 
                    buildInputs = [ "which" ]; # which is needed for the autogen.sh
                  };
    # python and ruby untested 
      python =            { cfgOption = "--enable-python"; #Enable build of python module
                            buildInputs=["python"] ++ (if args.use_svn then ["libtool" "autoconf" "automake" "swig"] else []); 
                          };
      ruby =              { cfgOption = "--enable-ruby"; };  #Enable build of ruby module
    }; 

    extraAttrs = co : {
      name = "geos-3.0.0rc4";

      src = if (args.use_svn) then
        args.fetchsvn { 
            url = http://svn.osgeo.org/geos/trunk; 
            md5 = "b46f5ea517a337064006bab92f3090d4";
        } else args.fetchurl {
          url = http://geos.refractions.net/geos-3.0.0rc4.tar.bz2;
          sha256 = "0pgwwv8q4p234r2jwdkaxcf68z2fwgmkc74c6dnmms2sdwkb5lbw";
        };

      configurePhase = "
        [ -f configure ] || \\
        LIBTOOLIZE=libtoolize ./autogen.sh
        #{ automake --add-missing; autoconf; }
        unset configurePhase; configurePhase
        ";

      meta = {
          description = "C++ port of the Java Topology Suite (JTS)"
            + "- all the OpenGIS \"Simple Features for SQL\" spatial predicate functions and spatial operators,"
            + " as well as specific JTS topology functions such as IsValid";
          homepage = http://geos.refractions.net/;
          license = "GPL";
      };
  };
} ) args
