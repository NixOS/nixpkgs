{ stdenv, runCommand, mutter, elementary-default-settings, nixos-artwork, glib, gala, epiphany, elementary-settings-daemon, gtk3, plank, gsettings-desktop-schemas
, extraGSettingsOverrides ? ""
, extraGSettingsOverridePackages ? []
}:

let

  gsettingsOverridePackages = [
    elementary-settings-daemon
    epiphany
    gala
    mutter
    gsettings-desktop-schemas
    gtk3
    plank
  ] ++ extraGSettingsOverridePackages;

in

with stdenv.lib;

# TODO: Having https://github.com/NixOS/nixpkgs/issues/54150 would supersede this
runCommand "elementary-gsettings-desktop-schemas" {}
  ''
     mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
     cp -rf ${gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     ${concatMapStrings (pkg: "cp -rf ${pkg}/share/gsettings-schemas/*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas\n") gsettingsOverridePackages}

     chmod -R a+w $out/share/gsettings-schemas/nixos-gsettings-overrides
     cp ${elementary-default-settings}/share/glib-2.0/schemas/20-io.elementary.desktop.gschema.override \
     $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     cat - > $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/nixos-defaults.gschema.override <<- EOF
     [org.gnome.desktop.background]
     picture-uri='${nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png'
     primary-color='#000000'

     ${extraGSettingsOverrides}
     EOF

     ${glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
  ''
