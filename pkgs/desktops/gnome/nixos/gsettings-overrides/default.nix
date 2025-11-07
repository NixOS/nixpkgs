{
  lib,
  runCommand,
  gsettings-desktop-schemas,
  gnome-shell,
  glib,
  gnome-flashback,
  nixos-artwork,
  nixos-background-light ? nixos-artwork.wallpapers.simple-blue,
  nixos-background-dark ? nixos-artwork.wallpapers.simple-dark-gray,
  extraGSettingsOverrides ? "",
  extraGSettingsOverridePackages ? [ ],
  favoriteAppsOverride ? "",
  flashbackEnabled ? false,
}:

let

  inherit (lib) concatMapStringsSep;

  gsettingsOverridePackages = [
    gsettings-desktop-schemas
    gnome-shell
  ]
  ++ lib.optionals flashbackEnabled [
    gnome-flashback
  ]
  ++ extraGSettingsOverridePackages;

  gsettingsOverrides = ''
    [org.gnome.desktop.background]
    picture-uri='file://${nixos-background-light.gnomeFilePath}'
    picture-uri-dark='file://${nixos-background-dark.gnomeFilePath}'

    [org.gnome.desktop.screensaver]
    picture-uri='file://${nixos-background-dark.gnomeFilePath}'

    ${favoriteAppsOverride}

    ${extraGSettingsOverrides}
  '';

in

runCommand "gnome-gsettings-overrides" { preferLocalBuild = true; } ''
  data_dir="$out/share/gsettings-schemas/nixos-gsettings-overrides"
  schema_dir="$data_dir/glib-2.0/schemas"
  mkdir -p "$schema_dir"

  ${concatMapStringsSep "\n" (
    pkg:
    "cp -rf \"${glib.getSchemaPath pkg}\"/*.xml \"${glib.getSchemaPath pkg}\"/*.gschema.override \"$schema_dir\""
  ) gsettingsOverridePackages}

  chmod -R a+w "$data_dir"
  cat - > "$schema_dir/zz-nixos-defaults.gschema.override" <<- EOF
  ${gsettingsOverrides}
  EOF

  ${glib.dev}/bin/glib-compile-schemas --strict "$schema_dir"
''
