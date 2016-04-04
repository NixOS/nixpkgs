{stdenv, fetchurl, javaCup, jre, apacheAnt}:

let
  soot =
    import ./soot {
      inherit stdenv fetchurl apacheAnt polyglot jasmin;
    };

  jasmin =
    import ./jasmin {
      inherit stdenv fetchurl apacheAnt javaCup;
    };

  polyglot =
    import ./polyglot {
      inherit stdenv fetchurl apacheAnt;
    };

  jedd =
    stdenv.mkDerivation {
      name = "jedd-runtime-snapshot";
      jarname = "jedd.runtime";
      builder = ./builder-binjar.sh;
      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.2.0/files/lib/jedd-runtime-snapshot.jar;
        md5 = "595c5ac2f6384f4c34f1854891b5e422";
      };
    };

  javabdd =
    stdenv.mkDerivation {
      name = "javabdd-0.6";
      jarname = "javabdd";
      builder = ./builder-binjar.sh;
      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.2.0/files/lib/javabdd_0.6.jar;
        md5 = "6e0246e891b7431f4e7265b5b1471307";
      };
    };

  paddle =
    stdenv.mkDerivation {
      name = "paddle-snapshot";
      jarname = "paddle";
      builder = ./builder-binjar.sh;
      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.2.0/files/lib/paddle-snapshot.jar;
        md5 = "a8e032310137945124a2850cd8cfc277";
      };
    };

  xact =
    stdenv.mkDerivation {
      name = "xact-complete-1.0-1";
      jarname = "xact";
      builder = ./builder-binjar.sh;
      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.2.0/files/lib/xact-complete-1.0-1.jar;
        md5 = "9810ad8762101ea691a895f0a6b7a5c3";
      };
    };
in

stdenv.mkDerivation {
  name = "abc-1.2.0";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://abc.comlab.ox.ac.uk/dists/1.2.0/files/abc-1.2.0-src.tar.gz;
    md5 = "aef9e8eac860f904f2a841e18770dc47";
  };

  inherit apacheAnt polyglot soot javaCup xact jasmin jre javabdd paddle jedd;
  patches = [];

  meta = {
    description = "The AspectBench Compiler for AspectJ";
  };
}
