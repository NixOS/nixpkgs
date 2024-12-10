{
  wrapGAppsHook3,
  glib,
  lib,
  stdenv,
  xorg,
  switchboard,
  switchboardPlugs,
  plugs,
  # Only useful to disable for development testing.
  useDefaultPlugs ? true,
  testName ? null,
}:

let
  selectedPlugs =
    if plugs == null then
      switchboardPlugs
    else
      plugs ++ (lib.optionals useDefaultPlugs switchboardPlugs);

  testingName = lib.optionalString (testName != null) "${testName}-";
in
stdenv.mkDerivation rec {
  pname = "${testingName}${switchboard.pname}-with-plugs";
  inherit (switchboard) version;

  src = null;

  paths = [
    switchboard
  ] ++ selectedPlugs;

  passAsFile = [ "paths" ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  buildInputs = lib.forEach selectedPlugs (x: x.buildInputs) ++ selectedPlugs;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    mkdir -p $out
    for i in $(cat $pathsPath); do
      ${xorg.lndir}/bin/lndir -silent $i $out
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set SWITCHBOARD_PLUGS_PATH "$out/lib/switchboard"
    )
  '';

  inherit (switchboard) meta;
}
