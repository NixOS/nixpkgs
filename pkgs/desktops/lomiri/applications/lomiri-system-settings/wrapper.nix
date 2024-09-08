{
  stdenvNoCC,
  lib,
  nixosTests,
  glib,
  lndir,
  lomiri-system-settings-online-accounts,
  lomiri-system-settings-unwrapped,
  wrapGAppsHook3,
  wrapQtAppsHook,
  plugins ? [ lomiri-system-settings-online-accounts ],
}:

let
  pluginsAndTheirExtraPrefixes = lib.lists.foldl (
    prefixes: plugin: prefixes ++ [ plugin ] ++ (plugin.passthru.extraSearchPrefixes or [ ])
  ) [ ] plugins;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-system-settings";
  inherit (lomiri-system-settings-unwrapped) version;

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
    lomiri-system-settings-unwrapped
  ]
  ++ pluginsAndTheirExtraPrefixes;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${lib.getExe lomiri-system-settings-unwrapped} $out/bin/${finalAttrs.meta.mainProgram}

    for inheritedPath in share/lomiri-app-launch share/lomiri-url-dispatcher share/applications share/icons; do
      mkdir -p $out/$inheritedPath
      lndir ${lomiri-system-settings-unwrapped}/$inheritedPath $out/$inheritedPath
    done

    for mergedPath in lib/lomiri-system-settings share/lomiri-system-settings share/accounts share/locale share/lomiri-online-accounts; do
      for lssPart in ${lomiri-system-settings-unwrapped} ${lib.strings.concatStringsSep " " pluginsAndTheirExtraPrefixes}; do
        if [ -d $lssPart/$mergedPath ]; then
          mkdir -p $out/$mergedPath
          lndir $lssPart/$mergedPath $out/$mergedPath
        fi
      done
    done

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --set NIX_LSS_PREFIX "$out"
      --set NIX_LOA_PLUGIN_DIR_PREFIX "$out/share"
      --set NIX_LOA_PRIVATE_MODULE_DIR_PREFIX "$out/lib"
    )
  '';

  passthru.tests.standalone = nixosTests.lomiri-system-settings;

  meta = lomiri-system-settings-unwrapped.meta // {
    description = "System Settings application for Lomiri (wrapped)";
    priority = (lomiri-system-settings-unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
  };
})
