{
  stdenvNoCC,
  fetchzip,
  fetchurl,
  lib,
  writeTextFile,
  buildFHSEnv,
  makeWrapper,
  jre,
  makeDesktopItem,
  copyDesktopItems,
  enableCorpusAndValidationModel ? false,
  enableDocumentation ? false,
  enableGUI ? true,
  enableMacAndNixScripts ? true,
  enableSamplePlugin ? false,
}:
let
  icon = fetchurl {
    name = "vera.png";
    url = "https://avatars.githubusercontent.com/u/9946925";
    hash = "sha256-i5tsVLlK6KBPQDgjvwTpcxFOMexwjygjUtGZgEYn4Yo=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "veraPDF-bin";
  version = "1.26.2";

  src = fetchzip {
    url = "https://software.verapdf.org/rel/${lib.versions.majorMinor finalAttrs.version}/verapdf-greenfield-${finalAttrs.version}-installer.zip";
    hash = "sha256-PtNZoXUjFbVI33StFffEI2FdZgkuwoWWEcMBny25bYw=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    jre
    makeWrapper
  ];

  installPhase =
    let
      gui = lib.boolToString enableGUI;
      doc = lib.boolToString enableDocumentation;
      scripts = lib.boolToString enableMacAndNixScripts;
      models = lib.boolToString enableCorpusAndValidationModel;
      plugin = lib.boolToString enableSamplePlugin;
      auto-install-xml = ''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <AutomatedInstallation langpack="eng">
        <com.izforge.izpack.panels.htmlhello.HTMLHelloPanel id="welcome"/>
        <com.izforge.izpack.panels.target.TargetPanel id="install_dir">
          <installpath>@out@/bin</installpath>
        </com.izforge.izpack.panels.target.TargetPanel>
        <com.izforge.izpack.panels.packs.PacksPanel id="sdk_pack_select">
          <pack index="0" name="veraPDF GUI" selected="${gui}"/>
          <pack index="1" name="veraPDF Mac and *nix Scripts" selected="${scripts}"/>
          <pack index="2" name="veraPDF Corpus and Validation model" selected="${models}"/>
          <pack index="3" name="veraPDF Documentation" selected="${doc}"/>
          <pack index="4" name="veraPDF Sample Plugins" selected="${plugin}"/>
        </com.izforge.izpack.panels.packs.PacksPanel>
        <com.izforge.izpack.panels.install.InstallPanel id="install"/>
        <com.izforge.izpack.panels.finish.FinishPanel id="finish"/>
        </AutomatedInstallation>
      '';
      auto-install = writeTextFile {
        name = "auto-install.xml";
        text = auto-install-xml;
      };

      # the installer expects chmod to be found in /bin/chmod
      installEnv = buildFHSEnv {
        name = "verapdf-installer-env";
        runScript = "./verapdf-install auto-install.xml";

        # https://github.com/NixOS/nixpkgs/issues/239017
        extraBwrapArgs = [
          "--bind $out $out"
        ];
      };
    in
    ''
      runHook preInstall

      substituteAll ${auto-install} auto-install.xml

      mkdir $out
      ${installEnv}/bin/${installEnv.name}

      rm -r $out/bin/{.installationinformation,Uninstaller}
      for i in $out/bin/verapdf{,-gui}; do
        wrapProgram $i --set JAVA_HOME ${jre}
      done

      install -Dm644 ${icon} $out/share/icons/hicolor/256x256/apps/verapdf.png

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "veraPDF";
      comment = finalAttrs.meta.description;
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
    description = "Industry Supported PDF/A Validation";
    homepage = "https://verapdf.org/";
    license = with lib.licenses; [
      gpl3Plus # or
      mpl20
    ];
    longDescription = ''
      purpose-built, open source, file-format validator covering all PDF/A parts and conformance levels
    '';
    mainProgram = "verapdf-gui";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
