{ jdk
, runCommand
, patchelf
, lib
, modules ? [
  "java.base"
  "java.compiler"
  "java.datatransfer"
  "java.desktop"
  "java.instrument"
  "java.logging"
  "java.management"
  "java.management.rmi"
  "java.naming"
  "java.net.http"
  "java.prefs"
  "java.rmi"
  "java.scripting"
  "java.security.jgss"
  "java.security.sasl"
  "java.se"
  "java.smartcardio"
  "java.sql"
  "java.sql.rowset"
  "java.transaction.xa"
  "java.xml"
  "java.xml.crypto"
  "jdk.unsupported"
]
}:

let
  jre = runCommand "${jdk.name}-jre" rec {
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
