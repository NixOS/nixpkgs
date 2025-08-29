{
  stdenvNoCC,
  lib,
  nixosTests,
  glib,
  lndir,
  lomiri-indicator-transfer-unwrapped,
  lomiri-indicator-transfer-buteo,
  wrapGAppsHook3,
  wrapQtAppsHook,
  plugins ? [
    lomiri-indicator-transfer-buteo
  ],
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-transfer";
  inherit (lomiri-indicator-transfer-unwrapped) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;

  nativeBuildInputs = [
    lndir
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  buildInputs = [
    glib # schema hook
    lomiri-indicator-transfer-unwrapped
  ] ++ plugins;

  installPhase = ''
    runHook preInstall

    for inheritedPath in share/ayatana; do
      mkdir -p $out/$inheritedPath
      lndir ${lomiri-indicator-transfer-unwrapped}/$inheritedPath $out/$inheritedPath
    done

    for updatedFile in \
      etc/xdg/autostart/lomiri-indicator-transfer.desktop \
      share/systemd/user/lomiri-indicator-transfer.service
    do
      mkdir -p "$(dirname $out/$updatedFile)"
      cp ${lomiri-indicator-transfer-unwrapped}/$updatedFile $out/$updatedFile
      substituteInPlace $out/$updatedFile \
        --replace-fail '${lomiri-indicator-transfer-unwrapped}' "$out"
    done

    for mergedPath in libexec/lomiri-indicator-transfer share/locale; do
      mkdir -p $out/$mergedPath
      for lssPart in ${lomiri-indicator-transfer-unwrapped} ${lib.strings.concatStringsSep " " plugins}; do
        lndir $lssPart/$mergedPath $out/$mergedPath
      done
    done

    runHook postInstall
  '';

  # Both apply wrapping to solibs in libexec
  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --set LOMIRI_INDICATOR_TRANSFER_PLUGINDIR "$out"
    )
  '';

  postFixup = ''
    wrapQtApp $out/libexec/lomiri-indicator-transfer/lomiri-indicator-transfer-service
  '';

  passthru = {
    ayatana-indicators = {
      lomiri-indicator-transfer = [ "lomiri" ];
    };
    tests.vm = nixosTests.ayatana-indicators;
  };

  meta = {
    inherit (lomiri-indicator-transfer-unwrapped.meta)
      homepage
      changelog
      license
      maintainers
      platforms
      ;
    description = lomiri-indicator-transfer-unwrapped.meta.description + " (wrapped)";
    priority = (lomiri-indicator-transfer-unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
  };
})
