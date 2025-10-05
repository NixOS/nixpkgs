{
  lib,
  fetchFromGitHub,
  maven,
  makeWrapper,
  stripJavaArchivesHook,
  makeDesktopItem,
  copyDesktopItems,
  jre,
}:
maven.buildMavenPackage rec {
  pname = "verapdf";
  version = "1.28.2";

  mvnParameters = "-pl '!installer' -Dverapdf.timestamp=1980-01-01T00:00:02Z -Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  src = fetchFromGitHub {
    owner = "veraPDF";
    repo = "veraPDF-apps";
    rev = "v${version}";
    hash = "sha256-tv5iffIQkyjHyulnmagcJuSGbc4tXRYTwB3hSEGLQrc=";
  };

  patches = [ ./stable-maven-plugins.patch ];

  # FIXME: this hash keeps changing over time??
  mvnHash = "sha256-+4ccnv0S7K/S2T7KryBJHJBEFrMZSFC7cNf3Kg/wN20=";

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share

    install -Dm644 greenfield-apps/target/greenfield-apps-${lib.versions.majorMinor version}.0.jar $out/share/verapdf.jar

    makeWrapper ${jre}/bin/java $out/bin/verapdf-gui --add-flags "-jar $out/share/verapdf.jar"
    makeWrapper ${jre}/bin/java $out/bin/verapdf --add-flags "-cp $out/share/verapdf.jar org.verapdf.apps.GreenfieldCliWrapper"

    install -Dm644 gui/src/main/resources/org/verapdf/gui/images/icon.png $out/share/icons/hicolor/256x256/apps/verapdf.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "veraPDF";
      comment = meta.description;
      desktopName = "veraPDF";
      genericName = "PDF/A Conformance Checker";
      exec = "verapdf-gui";
      icon = "verapdf";
      categories = [
        "Development"
        "Utility"
      ];
      keywords = [ "PDF" ];
      mimeTypes = [ "application/pdf" ];
    })
  ];

  meta = {
    description = "Command line and GUI industry supported PDF/A and PDF/UA Validation";
    homepage = "https://github.com/veraPDF/veraPDF-apps";
    license = [
      lib.licenses.gpl3Plus
      # or
      lib.licenses.mpl20
    ];
    mainProgram = "verapdf-gui";
    maintainers = [
      lib.maintainers.mohe2015
      lib.maintainers.kilianar
    ];
  };
}
