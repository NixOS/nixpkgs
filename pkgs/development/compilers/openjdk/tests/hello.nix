{ jdk
, jre
, pkgs
}:

/* 'Hello world' Java application derivation for use in tests */
let
  source = pkgs.writeTextDir "src/Hello.java" ''
    class Hello {
      public static void main(String[] args) {
        System.out.println("Hello, world!");
      }
    }
  '';
in
  pkgs.stdenv.mkDerivation {
    pname = "hello";
    version = "1.0.0";

    src = source;

    buildPhase = ''
      runHook preBuild
      ${jdk}/bin/javac src/Hello.java
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp src/Hello.class $out/lib

      mkdir -p $out/bin
      cat >$out/bin/hello <<EOF;
      #!/usr/bin/env sh
      ${jre}/bin/java -cp $out/lib Hello
      EOF
      chmod a+x $out/bin/hello

      runHook postInstall
    '';
  }
