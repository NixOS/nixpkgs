{
  stdenvNoCC,
  lib,
  fetchurl,
  makeWrapper,
  writeText,
  makeDesktopItem,
  copyDesktopItems,
  jre,
}:
let
  icon = fetchurl {
    # In case tigerjython/tjinstall becomes unavailable, use this url - see comment for src in MkDerivation
    #url = "https://web.archive.org/web/20240623120114/https://raw.githubusercontent.com/tigerjython/tjinstall/master/tjlogo64.png";
    url = "https://raw.githubusercontent.com/tigerjython/tjinstall/611c56d4e765731883656a5c4b71209d72b5ab74/tjlogo64.png";
    hash = "sha256-tw3uDWLtcMHYmN6JGsEvVKLgI09v5DF27V2+OF9Z5tA=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tigerjython";

  # UPDATE instructions
  #
  # We cache potentially unstable upstream input (.tar.gz file) via https://web.archive.org - this is a common procedure in Nixpkgs.
  #
  # - Open https://tigerjython.ch/en/products/download and identify the new version string for "TigerJython IDE for Linux"
  version = "2.40";

  # - and copy download link (most likely https://tjgroup.ch/user/pages/download/TigerJython.tar.gz) to clipboard.
  # - Open http://web.archive.org and paste download link from clipboard into "Save Page Now" field and hit the "Save Page" button.
  # - Unselect "Save Error Pages" and hit "Save Page" again.
  # - Wait for the archive link to be generated and copy it to the url field - adjust hash accordingly.
  src = fetchurl {
    url = "http://web.archive.org/web/20250104142121/https://tjgroup.ch/download/TigerJython.tar.gz";
    hash = "sha256-V/POFftRs/jjgNaHOrKcW2AdlQY2yjO+xiwJi63oECo=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "TigerJython";
      desktopName = "TigerJython";
      comment = "The Python IDE for beginners";
      type = "Application";
      categories = [ "Education" ];
      terminal = false;
      startupNotify = false;
      exec = "tigerjython";
      icon = "tigerjython";
      mimeTypes = [ "text/x-python" ];
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  # https://tobiaskohn.ch/jython/faq.html
  # Q: Can I install TigerJython for multiple users?
  # A: Yes, create a config file.
  # This file must be named tigerjython2.cfg and located
  # in the same folder as tigerjython2.jar
  tjconfig = writeText "tjconfig" ''
    configfile = sys.userpath + ".tjython.cfg"
    jython.cachedir = sys.userpath + ".jython.cache"
  '';

  installPhase = ''
    runHook preInstall

    export CUSTOM_LIBS=$out/share/java
    export JAR=$CUSTOM_LIBS/tigerjython2.jar
    export CFG=$CUSTOM_LIBS/tigerjython2.cfg
    export ADDITIONAL_LIBS_DIR=$CUSTOM_LIBS/Lib
    export EXAMPLES_DIR=$CUSTOM_LIBS/TestSamples

    install -Dm444 bin/tigerjython2.jar $JAR
    install -Dm444 bin/Lib/* --target-directory=$ADDITIONAL_LIBS_DIR
    install -Dm444 bin/TestSamples/* --target-directory=$EXAMPLES_DIR

    install -Dm444 $tjconfig $CFG

    makeWrapper ${jre}/bin/java $out/bin/tigerjython \
      --add-flags "-Duser.dir=$CUSTOM_LIBS/" \
      --add-flags "-Xmx512M" \
      --add-flags "-jar $JAR" \
      --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp"

    runHook postInstall
  '';

  postInstall = ''
    install -Dm444 ${icon} $out/share/icons/hicolor/64x64/apps/tigerjython.png
  '';

  meta = {
    homepage = "https://www.tigerjython.ch";
    downloadPage = "https://tigerjython.ch/en/products/download";
    description = "Simple development environment for programming in Python";
    longDescription = ''
      Designing, coding, and amazing. TigerJython offers everything you need
      to go from Python programming beginner to professional.
      You will find a wide variety of tutorials and can get started right away
      in programming environments specially developed for you.
    '';
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ rcmlz ];
    platforms = lib.platforms.all;
    mainProgram = "tigerjython";
  };
})
