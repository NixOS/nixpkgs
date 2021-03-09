{ stdenv
, jdk
, lib
, modules ? [ "java.base" ]
}:

let
  jre = stdenv.mkDerivation {
    name = "${jdk.name}-minimal-jre";
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
    };
  };
in jre
