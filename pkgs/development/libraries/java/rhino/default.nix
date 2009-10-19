{ fetchurl, stdenv, unzip, ant, javac, jvm }:

let
  version = "1.7R2";
  options = "-Dbuild.compiler=gcj";   # FIXME: We assume GCJ here.

  xbeans  = fetchurl {
    url = "http://www.apache.org/dist/xmlbeans/binaries/xmlbeans-2.2.0.zip";
    sha256 = "1pb08d9j81d0wz5wj31idz198iwhqb7mch872n08jh1354rjlqwk";
  };
in
  stdenv.mkDerivation {
    name = "rhino-${version}";

    src = fetchurl {
      url = "ftp://ftp.mozilla.org/pub/mozilla.org/js/rhino1_7R2.zip";
      sha256 = "1p32hkghi6bkc3cf2dcqyaw5cjj7403mykcp0fy8f5bsnv0pszv7";
    };

    patches = [ ./gcj-type-mismatch.patch ];

    preConfigure =
      '' find -name \*.jar -or -name \*.class -exec rm -v {} \;

         # The build process tries to download it by itself.
         ensureDir "build/tmp-xbean"
         ln -sv "${xbeans}" "build/tmp-xbean/xbean.zip"
      '';

    buildInputs = [ unzip ant javac jvm ];

    buildPhase = "ant ${options} jar";
    doCheck    = false;

    # FIXME: Install javadoc as well.
    installPhase =
      '' ensureDir "$out/lib/java"
         cp -v *.jar "$out/lib/java"
      '';

    meta = {
      description = "Mozilla Rhino: JavaScript for Java";

      longDescription =
        '' Rhino is an open-source implementation of JavaScript written
           entirely in Java.  It is typically embedded into Java applications
           to provide scripting to end users.
        '';

      homepage = http://www.mozilla.org/rhino/;

      licenses = [ "MPLv1.1" /* or */ "GPLv2+" ];

      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
