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
, extraGSettingsOverridePackages ? [ ]
}:

let

  inherit (lib) concatMapStringsSep;

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


# TODO: Having https://github.com/NixOS/nixpkgs/issues/54150 would supersede this
runCommand "elementary-gsettings-desktop-schemas" { preferLocalBuild = true; }
  ''
    data_dir="$out/share/gsettings-schemas/nixos-gsettings-overrides"
    schema_dir="$data_dir/glib-2.0/schemas"

    mkdir -p "$schema_dir"
    cp -rf "${glib.getSchemaPath gala}"/*.gschema.override "$schema_dir"

    ${concatMapStringsSep "\n" (pkg: "cp -rf \"${glib.getSchemaPath pkg}\"/*.xml \"$schema_dir\"") gsettingsOverridePackages}

    chmod -R a+w "$data_dir"
    cp "${glib.getSchemaPath elementary-default-settings}"/* "$schema_dir"

    cat - > "$schema_dir/nixos-defaults.gschema.override" <<- EOF
    ${extraGSettingsOverrides}
    EOF

    ${glib.dev}/bin/glib-compile-schemas $schema_dir
  ''
