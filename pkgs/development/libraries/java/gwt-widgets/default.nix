{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gwt-widgets";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/gwt-widget/gwt-widgets-${version}-bin.tar.gz";
    sha256 = "09isj4j6842rj13nv8264irkjjhvmgihmi170ciabc98911bakxb";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp gwt-widgets-*.jar $out/share/java

    runHook postInstall
  '';

  meta = with lib; {
    platforms = platforms.unix;
    license = with licenses; [ afl21 lgpl2 ];
  };
}
