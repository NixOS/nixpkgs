{ lib
, stdenv
, runCommand
, glib
, gtk3
, dde-dock
, startdde
, dde-session-shell
, dde-file-manager
, deepin-desktop-schemas
, deepin-movie-reborn
, deepin-screen-recorder
, deepin-system-monitor
, gsettings-desktop-schemas
, extraGSettingsOverrides ? ""
, extraGSettingsOverridePackages ? [ ]
}:

let
  gsettingsOverridePackages = [
    dde-dock
    startdde
    dde-session-shell
    dde-file-manager
    deepin-desktop-schemas
    deepin-movie-reborn
    deepin-screen-recorder
    deepin-system-monitor
    gsettings-desktop-schemas # dde-appearance need org.gnome.desktop.background
  ] ++ extraGSettingsOverridePackages;

in
with lib;

# TODO: Having https://github.com/NixOS/nixpkgs/issues/54150 would supersede this
runCommand "nixos-gsettings-desktop-schemas" { preferLocalBuild = true; }
''
    data_dir="$out/share/gsettings-schemas/nixos-gsettings-overrides"
    schema_dir="$data_dir/glib-2.0/schemas"

    mkdir -p $schema_dir

    ${concatMapStringsSep "\n" (pkg: "cp -rf \"${glib.getSchemaPath pkg}\"/*.xml \"$schema_dir\"") gsettingsOverridePackages}

    chmod -R a+w "$data_dir"

    cat - > "$schema_dir/nixos-defaults.gschema.override" <<- EOF
    ${extraGSettingsOverrides}
    EOF

    ${glib.dev}/bin/glib-compile-schemas $schema_dir
  ''
