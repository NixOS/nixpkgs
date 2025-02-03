{ lib, stdenv, fetchurl, makeWrapper, jdk17, gawk }:

stdenv.mkDerivation (finalAttrs: {
  pname = "youtrack";
  version = "2022.3.65371";

  jar = fetchurl {
    url = "https://download.jetbrains.com/charisma/youtrack-${finalAttrs.version}.jar";
    sha256 = "sha256-NQKWmKEq5ljUXd64zY27Nj8TU+uLdA37chbFVdmwjNs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    makeWrapper ${jdk17}/bin/java $out/bin/youtrack \
      --add-flags "\$YOUTRACK_JVM_OPTS -jar $jar" \
      --prefix PATH : "${lib.makeBinPath [ gawk ]}" \
      --set JRE_HOME ${jdk17}
    runHook postInstall
  '';

  meta = {
    description = "Issue tracking and project management tool for developers";
    maintainers = lib.teams.serokell.members ++ [ lib.maintainers.leona ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    # https://www.jetbrains.com/youtrack/buy/license.html
    license = lib.licenses.unfree;
  };
})
