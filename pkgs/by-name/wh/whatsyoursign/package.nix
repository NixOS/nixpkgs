{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "whatsyoursign";
  version = "3.2.1";

  src = fetchurl {
    url = "https://github.com/objective-see/WhatsYourSign/releases/download/v${finalAttrs.version}/WhatsYourSign_${finalAttrs.version}.zip";
    hash = "sha256-lO4c3MWbWkTgaA3bzn0HDZXewx5QLfs5zOhh5nan+Tg=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R "WhatsYourSign Installer.app" $out/Applications/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.has-app = runCommand "whatsyoursign-has-app" { } ''
      test -d "${finalAttrs.finalPackage}/Applications/WhatsYourSign Installer.app"
      test -x "${finalAttrs.finalPackage}/Applications/WhatsYourSign Installer.app/Contents/MacOS/WhatsYourSign Installer"
      touch $out
    '';
  };

  meta = {
    description = "macOS Finder extension that shows code signing and hash info for files";
    homepage = "https://objective-see.org/products/whatsyoursign.html";
    changelog = "https://github.com/objective-see/WhatsYourSign/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/objective-see/WhatsYourSign/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "WhatsYourSign Installer";
  };
})
