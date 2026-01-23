{
  stdenv,
  lib,
  glib,
  wrapGAppsHook3,
  xorg,
  marco,
  mate-panel,
  panelApplets,
  applets ? [ ],
  useDefaultApplets ? true,
}:

let
  selectedApplets = applets ++ (lib.optionals useDefaultApplets panelApplets);
in
stdenv.mkDerivation {
  pname = "${mate-panel.pname}-with-applets";
  inherit (mate-panel) version outputs;

  src = null;

  paths = [
    mate-panel.out
    mate-panel.man
  ]
  ++ selectedApplets;
  passAsFile = [ "paths" ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  buildInputs =
    lib.forEach selectedApplets (x: x.buildInputs)
    ++ selectedApplets
    ++ [ mate-panel ]
    ++ mate-panel.buildInputs
    ++ mate-panel.propagatedBuildInputs;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    for i in $(cat $pathsPath); do
      ${xorg.lndir}/bin/lndir -silent $i $out
    done

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set MATE_PANEL_APPLETS_DIR "$out/share/mate-panel/applets"
      --set MATE_PANEL_EXTRA_MODULES "$out/lib/mate-panel/applets"
      # Workspace switcher settings
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath marco}"
    )
  '';

  inherit (mate-panel) meta;
}
