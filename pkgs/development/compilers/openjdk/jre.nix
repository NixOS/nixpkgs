{
  stdenv,
  jdk,
  lib,
  callPackage,
  modules ? [ "java.base" ],
}:

let
  jre = stdenv.mkDerivation {
    pname = "${jdk.pname}-minimal-jre";
    version = jdk.version;

    buildInputs = [ jdk ];

    dontUnpack = true;

    # Strip more heavily than the default '-S', since if you're
    # using this derivation you probably care about this.
    stripDebugFlags = [ "--strip-unneeded" ];

    buildPhase = ''
      runHook preBuild

      jlink --module-path ${jdk}/lib/openjdk/jmods --add-modules ${lib.concatStringsSep "," modules} --output $out

      runHook postBuild
    '';

    dontInstall = true;

    passthru = {
      home = "${jre}";
      tests = [
        (callPackage ./tests/test_jre_minimal.nix { })
        (callPackage ./tests/test_jre_minimal_with_logging.nix { })
      ];
    };
  };
in
jre
