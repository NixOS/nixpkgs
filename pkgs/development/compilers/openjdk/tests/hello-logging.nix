{ jdk
, jre
, pkgs
}:

/* 'Hello world' Java application derivation for use in tests */
let
  source = pkgs.writeTextDir "src/Hello.java" ''
    import java.util.logging.Logger;
    import java.util.logging.Level;

    class Hello {
      static Logger logger = Logger.getLogger(Hello.class.getName());

      public static void main(String[] args) {
        logger.log(Level.INFO, "Hello, world!");
      }
    }
  '';
in
  pkgs.stdenv.mkDerivation {
    pname = "hello";
    version = "1.0.0";

    src = source;

    buildPhase = ''
      runHook preBuildPhase
      ${jdk}/bin/javac src/Hello.java
      runHook postBuildPhase
    '';
    installPhase = ''
      runHook preInstallPhase

      mkdir -p $out/lib
      cp src/Hello.class $out/lib

      mkdir -p $out/bin
      cat >$out/bin/hello <<EOF;
      #!/usr/bin/env sh
      ${jre}/bin/java -cp $out/lib Hello
      EOF
      chmod a+x $out/bin/hello

      runHook postInstallPhase
    '';
  }
