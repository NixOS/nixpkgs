{
  stdenvNoCC,
  lib,
  lndir,
  lomiri-notes-app,
  lomiri-online-accounts-unwrapped,
  lomiri-online-accounts-plugins,
  wrapQtAppsHook,
  accountsSsoPackages ? [
    lomiri-notes-app
    lomiri-online-accounts-plugins
  ],
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-online-accounts";
  inherit (lomiri-online-accounts-unwrapped) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;

  nativeBuildInputs = [
    lndir
    wrapQtAppsHook
  ];

  buildInputs = [
    lomiri-online-accounts-unwrapped
  ]
  ++ accountsSsoPackages;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    lndir ${lomiri-online-accounts-unwrapped}/bin $out/bin

    for inheritedPath in share/applications share/click share/dbus-1/interfaces share/locale; do
      mkdir -p $out/$inheritedPath
      lndir ${lomiri-online-accounts-unwrapped}/$inheritedPath $out/$inheritedPath
    done

    mkdir -p $out/share/dbus-1/services
    for dbusService in ${lomiri-online-accounts-unwrapped}/share/dbus-1/services/*; do
      outService=$out/share/dbus-1/services/"$(basename "$dbusService")"
      cp -v $dbusService $outService
      substituteInPlace $outService \
        --replace-fail '${lomiri-online-accounts-unwrapped}' "$out"
    done

    for mergedPath in share/accounts share/icons share/locale share/lomiri-online-accounts; do
      for lssPart in ${lomiri-online-accounts-unwrapped} ${lib.strings.concatStringsSep " " accountsSsoPackages}; do
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
      --set NIX_LOA_PLUGIN_DIR_PREFIX "$out/share"
      --set NIX_LOA_PRIVATE_MODULE_DIR_PREFIX "$out/lib"
    )
  '';

  meta = lomiri-online-accounts-unwrapped.meta // {
    description = "${lomiri-online-accounts-unwrapped.meta.description} (wrapped)";
    priority = (lomiri-online-accounts-unwrapped.meta.priority or lib.meta.defaultPriority) - 1;
  };
})
