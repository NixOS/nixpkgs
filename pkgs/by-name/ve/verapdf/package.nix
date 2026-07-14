{
  lib,
  fetchFromGitHub,
  maven,
  makeWrapper,
  stripJavaArchivesHook,
  makeDesktopItem,
  copyDesktopItems,
  jre,
  versionCheckHook,
  withCli ? true,
  withGui ? false,
}:
maven.buildMavenPackage rec {
  pname = "verapdf" + lib.optionalString (withGui && !withCli) "-gui";
  version = "1.30.1";
  __structuredAttrs = true;

  mvnParameters =
    "-pl '!installer' -Dverapdf.timestamp=1980-01-01T00:00:02Z -Dproject.build.outputTimestamp=1980-01-01T00:00:02Z "
    +
      # By default, veraPDF uses version ranges for some components.
      # These versions are pinned to the package version in order to avoid
      # non-reproducibility of the maven dependencies.
      lib.concatMapStringsSep " " (id: "-Dverapdf.${id}.version=${version}") [
        "library"
        "pdfbox.validation"
        "validation"
      ];

  src = fetchFromGitHub {
    owner = "veraPDF";
    repo = "veraPDF-apps";
    tag = "v${version}";
    hash = "sha256-IoQbAYEUJuK5FxGSxiLfcn5X1KOJca70hu4cMaYXfmw=";
  };

  patches = [ ./stable-maven-plugins.patch ];

  mvnHash = "sha256-hY+zPuSujMr3RntuLOZVEN8GN4n8201+S5OYvwB1+j4=";

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
  ''
  + lib.optionalString withCli ''
    install -Dm644 cli/target/cli-${lib.versions.majorMinor version}.0.jar $out/share/verapdf.jar
    makeWrapper ${lib.getExe jre} $out/bin/verapdf --add-flags "-jar $out/share/verapdf.jar"
  ''
  + lib.optionalString withGui ''
    install -Dm644 gui/target/gui-${lib.versions.majorMinor version}.0.jar $out/share/verapdf-gui.jar
    makeWrapper ${lib.getExe jre} $out/bin/verapdf-gui --add-flags "-jar $out/share/verapdf-gui.jar"

    install -Dm644 gui/src/main/resources/org/verapdf/gui/images/icon.png $out/share/icons/hicolor/256x256/apps/verapdf.png
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optionals withGui [
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

  # GUI has no --version flag
  doInstallCheck = withCli;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/verapdf";

  preVersionCheck = ''
    version=${lib.versions.majorMinor version}.0
  '';

  meta = {
    changelog = "https://github.com/veraPDF/veraPDF-library/blob/${src.tag}/RELEASENOTES.md";
    description = "Command line and GUI industry supported PDF/A and PDF/UA Validation";
    homepage = "https://github.com/veraPDF/veraPDF-apps";
    license = [
      lib.licenses.gpl3Plus
      # or
      lib.licenses.mpl20
    ];
    maintainers = [
      lib.maintainers.mohe2015
      lib.maintainers.kilianar
    ];
  }
  // lib.optionalAttrs (withCli && !withGui) {
    mainProgram = "verapdf";
  }
  // lib.optionalAttrs (withGui && !withCli) {
    mainProgram = "verapdf-gui";
  };
}
