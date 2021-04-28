{lib, stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gwt-widgets-0.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/gwt-widget/gwt-widgets-0.2.0-bin.tar.gz";
    sha256 = "09isj4j6842rj13nv8264irkjjhvmgihmi170ciabc98911bakxb";
  };

  dontUnpack = true;

  installPhase = ''
    tar xfvz $src
    cd gwt-widgets-*
    mkdir -p $out/share/java
    cp gwt-widgets-*.jar $out/share/java
  '';

  meta = with lib; {
    platforms = platforms.unix;
    license = with licenses; [ afl21 lgpl2 ];
  };
}
