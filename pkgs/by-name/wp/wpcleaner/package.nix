{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  jdk17,
  ant,
  stripJavaArchivesHook,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wpcleaner";
  version = "2.0.5-unstable-2025-04-25";
  src = fetchFromGitHub {
    owner = "WPCleaner";
    repo = "wpcleaner";
    rev = "7fd357cf26349658183517658139870dd45eaedc";
    hash = "sha256-iaAP/5Z+ghvMAn4ke7lhRqKov/3jXr0LMwbPDZ052j0=";
  };

  wpcleanerJar = "$out/share/wpcleaner/WikipediaCleaner.jar";
  clientScript = "$out/bin/wpcleaner";
  botScript = "$out/bin/wpcleaner-bot";
  runTaskScript = "$out/bin/wpcleaner-run-task";
  extraJavaArgs = [
    "-Dawt.useSystemAAFontSettings=lcd"
    "-Xms1g"
    "-Xmx8g"
  ];

  dontConfigure = true;

  patches = [
    ./0001-fix-script-names-and-remove-getdown.patch
    ./0002-dont-build-javadoc.patch
  ];

  nativeBuildInputs = [
    jdk17
    ant
    gettext
    makeWrapper
    copyDesktopItems
    stripJavaArchivesHook
  ];

  buildInputs = [ jdk17 ];

  buildPhase = ''
    runHook preBuild

    cd WikipediaCleaner
    echo "" | ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm744 build/dist/full/WikipediaCleaner.jar ${finalAttrs.wpcleanerJar}
    install -Dm744 resources/getdown/WPCleaner.sh ${finalAttrs.clientScript}
    install -Dm744 resources/getdown/Bot.sh ${finalAttrs.botScript}
    install -Dm744 run-task.sh ${finalAttrs.runTaskScript}

    substituteInPlace \
      ${finalAttrs.clientScript} ${finalAttrs.botScript} ${finalAttrs.runTaskScript} \
      --subst-var-by wpcleaner_jar "${finalAttrs.wpcleanerJar}" \
      --subst-var-by tasks "$out/share/wpcleaner/tasks"

    wrapProgram ${finalAttrs.clientScript} \
      --prefix PATH : ${lib.makeBinPath [ jdk17 ]} \
      --prefix JAVA_JDK_OPTIONS " " "${lib.strings.concatStringsSep " " finalAttrs.extraJavaArgs}"
    wrapProgram ${finalAttrs.botScript} \
      --prefix PATH : ${lib.makeBinPath [ jdk17 ]} \
      --prefix JAVA_JDK_OPTIONS " " "${lib.strings.concatStringsSep " " finalAttrs.extraJavaArgs}"
    wrapProgram ${finalAttrs.runTaskScript} \
      --prefix PATH : ${lib.makeBinPath [ jdk17 ]} \
      --prefix JAVA_JDK_OPTIONS " " "${lib.strings.concatStringsSep " " finalAttrs.extraJavaArgs}"

    cp -r resources/tasks $out/share/wpcleaner
    install -Dm644 resources/commons-nuvola-web-broom-64px.png $out/share/icons/hicolor/64x64/apps/wpcleaner.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "wpcleaner";
      desktopName = "WPCleaner";
      comment = "Perform maintenance on Wikipedia";
      icon = "wpcleaner";
      exec = "wpcleaner";
      categories = [ "Utility" ];
      keywords = [ "Wikipedia" ];
    })
  ];

  meta = with lib; {
    description = "An utility for performing maintenance on Wikipedia";
    longDescription = ''
      WPCleaner is a tool designed to help with various maintenance tasks, especially repairing
      links to disambiguation pages, checking Wikipedia, fixing spelling and typography, and
      helping with translation of articles coming from other wikis.
    '';
    homepage = "https://wpcleaner.toolforge.org/";
    downloadPage = "https://github.com/WPCleaner/wpcleaner";
    license = lib.licenses.asl20;
    mainProgram = "wpcleaner";
    platforms = lib.platforms.all;
    maintainers = with maintainers; [ jeancaspar ];
  };
})
