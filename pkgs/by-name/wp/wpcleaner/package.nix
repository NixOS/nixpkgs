{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeBinaryWrapper,
  jdk17,
  ant,
  stripJavaArchivesHook,
  gettext,
}:

let
  wpcleanerJar = "$out/share/wpcleaner/WikipediaCleaner.jar";
  clientScript = "$out/bin/wpcleaner";
  botScript = "$out/bin/wpcleaner-bot";
  runTaskScript = "$out/bin/wpcleaner-run-task";
  extraJavaArgs = [
    "-Dawt.useSystemAAFontSettings=gasp"
    "-Xms1g"
    "-Xmx8g"
  ];
in
stdenv.mkDerivation {
  pname = "wpcleaner";
  version = "2.0.5-unstable-2025-04-25";
  src = fetchFromGitHub {
    owner = "WPCleaner";
    repo = "wpcleaner";
    rev = "7fd357cf26349658183517658139870dd45eaedc";
    hash = "sha256-iaAP/5Z+ghvMAn4ke7lhRqKov/3jXr0LMwbPDZ052j0=";
  };

  dontConfigure = true;

  patches = [
    # The names of the scripts are too generic (e.g. Bot.sh) and the scripts
    # run the jar through getdown, which is a tool which checks if there is a
    # new version of the jar automatically and update itself if it is the case,
    # therefore we want to disable it.
    ./0001-fix-script-names-and-remove-getdown.patch
    # Building the documentation requires internet access to docs.oracle.com,
    # which is not available at build time and is not useful to the user.
    ./0002-dont-build-javadoc.patch
  ];

  nativeBuildInputs = [
    jdk17
    ant
    gettext
    makeBinaryWrapper
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

    install -Dm744 build/dist/full/WikipediaCleaner.jar ${wpcleanerJar}
    install -Dm744 resources/getdown/WPCleaner.sh ${clientScript}
    install -Dm744 resources/getdown/Bot.sh ${botScript}
    install -Dm744 run-task.sh ${runTaskScript}

    substituteInPlace \
      ${clientScript} ${botScript} ${runTaskScript} \
      --subst-var-by wpcleaner_jar "${wpcleanerJar}" \
      --subst-var-by tasks "$out/share/wpcleaner/tasks"

    wrapProgram ${clientScript} \
      --prefix PATH : ${lib.makeBinPath [ jdk17 ]} \
      --prefix JAVA_JDK_OPTIONS " " "${lib.strings.concatStringsSep " " extraJavaArgs}"
    wrapProgram ${botScript} \
      --prefix PATH : ${lib.makeBinPath [ jdk17 ]} \
      --prefix JAVA_JDK_OPTIONS " " "${lib.strings.concatStringsSep " " extraJavaArgs}"
    wrapProgram ${runTaskScript} \
      --prefix PATH : ${lib.makeBinPath [ jdk17 ]} \
      --prefix JAVA_JDK_OPTIONS " " "${lib.strings.concatStringsSep " " extraJavaArgs}"

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

  meta = {
    description = "Utility for performing maintenance on Wikipedia";
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
    maintainers = with lib.maintainers; [ jeancaspar ];
  };
}
