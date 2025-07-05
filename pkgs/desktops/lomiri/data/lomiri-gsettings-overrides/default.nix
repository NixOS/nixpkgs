{
  lib,
  runCommand,
  glib,
  lomiri-schemas,
  lomiri-wallpapers,
  nixos-icons,
  writeText,
  extraGSettingsOverrides ? "",
  extraGSettingsOverridePackages ? [ ],
  nixos-artwork,
}:

let
  # Overriding the background picture should be possible, but breaks within the VM tests.
  # It results in either a grey background (prolly indicating an error somewhere)
  # or hangs the session (also happens when using LSS, which sets it via AccountsService).
  #
  # So we can only override the launcher button details.
  # Button colour: https://github.com/NixOS/nixos-artwork/blob/51a27e4a011e95cb559e37d32c44cf89b50f5154/logo/README.md#colours
  gsettingsOverrides = writeText "lomiri-gschema-overrides" ''
    [com.lomiri.Shell.Launcher]
    logo-picture-uri='file://${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg'
    home-button-background-color='#5277C3'

    ${extraGSettingsOverrides}
  '';

  gsettingsOverridePackages = [
    lomiri-schemas
  ] ++ extraGSettingsOverridePackages;
in
runCommand "lomiri-gsettings-overrides" { preferLocalBuild = true; } ''
  dataDir="$out/share/gsettings-schemas/nixos-gsettings-overrides"
  schemaDir="$dataDir/glib-2.0/schemas"
  mkdir -p "$schemaDir"

  ${lib.strings.concatMapStringsSep "\n" (
    pkg:
    "cp -rf \"${glib.getSchemaPath pkg}\"/*.xml \"${glib.getSchemaPath pkg}\"/*.gschema.override \"$schemaDir\""
  ) gsettingsOverridePackages}

  chmod -R a+w "$dataDir"
  cp --no-preserve=mode "${gsettingsOverrides}" "$schemaDir/zz-nixos-defaults.gschema.override"

  ${lib.getExe' glib.dev "glib-compile-schemas"} --strict "$schemaDir" | tee gcs.log

  if grep 'No schema files found' gcs.log >/dev/null; then
    exit 1
  fi
''
