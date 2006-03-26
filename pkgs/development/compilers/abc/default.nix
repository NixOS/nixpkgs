{stdenv, fetchurl, javaCup, jre, apacheAnt, patches} :

let { 
  body =
    stdenv.mkDerivation {
      name = "abc-1.1.1";
      builder = ./builder.sh;

      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.1.1/files/abc-1.1.1-src.tar.gz;
        md5 = "6479e151d0a00633f7aa7c31c93c439e";
      };

      inherit apacheAnt polyglot soot javaCup xact jasmin jre javabdd paddle jedd patches;
    };

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
        url = http://abc.comlab.ox.ac.uk/dists/1.1.1/files/lib/jedd-runtime-snapshot.jar;
        md5 = "595c5ac2f6384f4c34f1854891b5e422";
      };
    };

  javabdd =
    stdenv.mkDerivation {
      name = "javabdd-0.6";
      jarname = "javabdd";
      builder = ./builder-binjar.sh;
      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.1.1/files/lib/javabdd_0.6.jar;
        md5 = "6e0246e891b7431f4e7265b5b1471307";
      };
    };

  paddle =
    stdenv.mkDerivation {
      name = "paddle-snapshot";
      jarname = "paddle";
      builder = ./builder-binjar.sh;
      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.1.1/files/lib/paddle-snapshot.jar;
        md5 = "a8e032310137945124a2850cd8cfc277";
      };
    };

  xact =
    stdenv.mkDerivation {
      name = "xact-complete-1.0-1";
      jarname = "xact";
      builder = ./builder-binjar.sh;
      src = fetchurl {
        url = http://abc.comlab.ox.ac.uk/dists/1.0.2/files/lib/xact-complete-1.0-1.jar;
        md5 = "9810ad8762101ea691a895f0a6b7a5c3";
      };
    };
}
