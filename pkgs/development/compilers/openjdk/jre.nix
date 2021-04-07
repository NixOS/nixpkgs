{ jdk
, runCommand
, patchelf
, lib
, modules ? [ "java.base" ]
}:

let
  jre = runCommand "${jdk.name}-jre" {
    nativeBuildInputs = [ patchelf ];
    buildInputs = [ jdk ];
    passthru = {
      home = "${jre}";
    };
  }   ''
      jlink --module-path ${jdk}/lib/openjdk/jmods --add-modules ${lib.concatStringsSep "," modules} --output $out
      patchelf --shrink-rpath $out/bin/* $out/lib/jexec $out/lib/jspawnhelper $out/lib/*.so $out/lib/*/*.so
  '';
in jre
