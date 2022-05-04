{ lib
, runCommand
, mutter
, elementary-default-settings
, glib
, gala
, epiphany
, gnome-settings-daemon
, gtk3
, elementary-dock
, gsettings-desktop-schemas
, extraGSettingsOverrides ? ""
, extraGSettingsOverridePackages ? []
}:

let

  gsettingsOverridePackages = [
    elementary-dock
    gnome-settings-daemon
    epiphany
    gala
    gsettings-desktop-schemas
    gtk3
    mutter
  ] ++ extraGSettingsOverridePackages;

in

with lib;

# TODO: Having https://github.com/NixOS/nixpkgs/issues/54150 would supersede this
runCommand "elementary-gsettings-desktop-schemas" {}
  ''
     schema_dir=$out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     mkdir -p $schema_dir

     cp -rf ${glib.getSchemaPath gala}/*.gschema.override $schema_dir

     ${concatMapStrings (pkg: "cp -rf ${glib.getSchemaPath pkg}/*.xml $schema_dir\n") gsettingsOverridePackages}

     chmod -R a+w $out/share/gsettings-schemas/nixos-gsettings-overrides
     cp ${glib.getSchemaPath elementary-default-settings}/* $schema_dir

     cat - > $schema_dir/nixos-defaults.gschema.override <<- EOF
     ${extraGSettingsOverrides}
     EOF

     ${glib.dev}/bin/glib-compile-schemas $schema_dir
  ''
