{ stdenv, fetchurl, ant, jdk, junit }:

stdenv.mkDerivation rec {
  name = "junixsocket-1.3";

  src = fetchurl {
    url = "http://junixsocket.googlecode.com/files/${name}-src.tar.bz2";
    sha256 = "0c6p8vmiv5nk8i6g1hgivnl3mpb2k3lhjjz0ss9dlirisfrxf1ym";
  };

  patches = [ ./darwin.patch ];

  buildInputs = [ ant jdk junit ];

  preConfigure =
    ''
      substituteInPlace src/main/org/newsclub/net/unix/NativeUnixSocketConfig.java \
        --replace /opt/newsclub/lib-native $out/lib
    '';

  buildPhase = "ant";

  ANT_ARGS =
    # Note that our OpenJDK on Darwin is currently 32-bit, so we have to build a 32-bit dylib.
    (if stdenv.is64bit then [ "-Dskip32=true" ] else [ "-Dskip64=true" ])
    ++ [ "-Dgcc=cc" "-Dant.build.javac.source=1.6" ]
    ++ stdenv.lib.optional stdenv.isDarwin "-DisMac=true";

  installPhase =
    ''
      mkdir -p $out/share/java $out/lib
      cp -v dist/*.jar $out/share/java
      cp -v lib-native/*.so lib-native/*.dylib $out/lib/
    '';

  meta = {
    description = "A Java/JNI library for using Unix Domain Sockets from Java";
    homepage = https://code.google.com/p/junixsocket/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
