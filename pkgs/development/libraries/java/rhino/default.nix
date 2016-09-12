{ fetchurl, stdenv, unzip, ant, javac, jvm }:

let
  version = "1.7R2";
  options = "-Dbuild.compiler=gcj";   # FIXME: We assume GCJ here.

  xbeans  = fetchurl {
    url = "http://archive.apache.org/dist/xmlbeans/binaries/xmlbeans-2.2.0.zip";
    sha256 = "1pb08d9j81d0wz5wj31idz198iwhqb7mch872n08jh1354rjlqwk";
  };
in

stdenv.mkDerivation {
  name = "rhino-${version}";

  src = fetchurl {
    url = "mirror://mozilla/js/rhino1_7R2.zip";
    sha256 = "1p32hkghi6bkc3cf2dcqyaw5cjj7403mykcp0fy8f5bsnv0pszv7";
  };

  patches = [ ./gcj-type-mismatch.patch ];

  hardeningDisable = [ "fortify" "format" ];

  preConfigure =
    ''
      find -name \*.jar -or -name \*.class -exec rm -v {} \;

      # The build process tries to download it by itself.
      mkdir -p "build/tmp-xbean"
      ln -sv "${xbeans}" "build/tmp-xbean/xbean.zip"
    '';

  buildInputs = [ unzip ant javac jvm ];

  buildPhase = "ant ${options} jar";
  doCheck    = false;

  # FIXME: Install javadoc as well.
  installPhase =
    ''
      mkdir -p "$out/share/java"
      cp -v *.jar "$out/share/java"
    '';

  meta = with stdenv.lib; {
    description = "An implementation of JavaScript written in Java";

    longDescription =
      '' Rhino is an open-source implementation of JavaScript written
         entirely in Java.  It is typically embedded into Java applications
         to provide scripting to end users.
      '';

    homepage = http://www.mozilla.org/rhino/;

    license = with licenses; [ mpl11 /* or */ gpl2Plus ];
    platforms = platforms.linux;
  };
}
