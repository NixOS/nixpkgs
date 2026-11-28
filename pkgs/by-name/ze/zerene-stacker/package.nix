{
  lib,
  stdenvNoCC,
  fetchzip,
  jdk17,
  wrapGAppsHook3,
}:
let
  platforms = {
    # TODO: add Windows
    x86_64-linux = {
      prefix = "Linux-Intel-64bit";
      hash = "sha256-3nUlXRJ6SLShqnlMSiRxNVTbtldJ0R4/wwS36dHhKtA=";
    };
    i686-linux = {
      prefix = "Linux-i386-32bit";
      hash = "sha256-EltZOwIxqOrWTDAFH85EnkSHZBArOc1Eur1IAKXy6Fw=";
    };
    x86_64-darwin = {
      prefix = "MacOSX-SA";
      hash = "sha256-UIQOpWLHjVOHcg9R4chDdgiTxHicpksldYWxRJmq6bg=";
    };
    aarch64-darwin = {
      prefix = "MacOSX-ARM-SA";
      hash = "sha256-tx0fs7wiwM6sEplugnN4hBfoSNNrQ2HPx2osNcJ0P7k=";
    };
  };

  inherit (platforms.${stdenvNoCC.hostPlatform.system}) prefix hash;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zerene-stacker";
  version = "2024-11-18-1210";

  src = fetchzip {
    url = "https://zerenesystems.com/stacker/downloads/ZS-${prefix}-T${finalAttrs.version}.zip";
    inherit hash;
  };

  # Required for things like file dialogs
  nativeBuildInputs = lib.optional stdenvNoCC.hostPlatform.isLinux wrapGAppsHook3;

  dontConfigure = true;
  dontBuild = true;

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      mkdir -p $out/{bin,lib}
      cp -r . -t $out/lib

      # The builtin JRE just sucks. Needs a lot of runtime patching that we can just avoid by using
      # the JRE available in Nixpkgs anyway
      rm -rf $out/lib/jre
      ln -s ${jdk17} $out/lib/jre
      ln -s $out/lib/ZereneStacker $out/bin/ZereneStacker
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      # TODO: do we want to replace the bundled JRE for Darwin as well?
      cp -r . $out/Applications/ZereneStacker.app
      ln -s $out/Applications/ZereneStacker.app/Contents/MacOS/zerenstk.zsmac $out/bin/ZereneStacker
    ''
    + ''
      runHook postInstall
    '';

  meta = {
    description = "Focus stacking software designed specifically for challenging macro subjects and discerning photographers";
    homepage = "https://zerenesystems.com/cms/stacker";
    changelog = "https://zerenesystems.com/cms/stacker/docs/modificationhistory";
    license = with lib.licenses; [ unfree ];
    platforms = lib.attrNames platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "ZereneStacker";
  };
})
