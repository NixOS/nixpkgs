{
  lib,
  stdenv,
  openjdk8,
  ant,
  makeWrapper,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "yass";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "SarutaSan72";
    repo = "Yass";
    tag = finalAttrs.version;
    hash = "sha256-eZomMlc8MRqekzRCTOxeN3gaxMmxQK2W61CTlKpUj6g=";
  };

  nativeBuildInputs = [
    openjdk8
    makeWrapper
  ];

  buildInputs = [ ant ];

  buildPhase = ''
    runHook preBuild

    export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
    ant -f build-jar.xml compile jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/yass

    cp release/yass-${finalAttrs.version}.jar $out/share/yass

    makeWrapper ${lib.getExe openjdk8} $out/bin/yass \
      --add-flags "-cp $out/share/yass/yass-${finalAttrs.version}.jar yass.YassMain"

    runHook postInstall
  '';

  meta = {
    description = "Karaoke Editor for finetuning Ultrastar Songs";
    homepage = "http://yass-along.com/";
    downloadPage = "https://github.com/SarutaSan72/Yass";
    changelog = "https://github.com/SarutaSan72/Yass/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _0x5a4 ];
    mainProgram = "yass";
  };
})
