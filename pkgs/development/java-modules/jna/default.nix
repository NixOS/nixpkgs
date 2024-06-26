{
  stdenv,
  lib,
  fetchFromGitHub,
  ant,
  jdk,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jna";
  version = "5.14.0";

  src = fetchFromGitHub {
    owner = "java-native-access";
    repo = "jna";
    rev = finalAttrs.version;
    hash = "sha256-a5l9khKLWfvTHv53utfbw344/UNQOnIU93+wZNQ0ji4=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    rm -r dist # remove prebuilt files
    ant dist
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out/share/java dist/jna{,-platform}.jar
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/java-native-access/jna/blob/${finalAttrs.version}/CHANGES.md";
    description = "Java Native Access";
    homepage = "https://github.com/java-native-access/jna";
    license = with licenses; [
      lgpl21
      asl20
    ];
    maintainers = with maintainers; [ nagy ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
