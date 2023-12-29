{ lib
, runCommand
, budgie-desktop
, budgie-desktop-view
, glib
, gsettings-desktop-schemas
, magpie
, mate
, nixos-artwork
, nixos-background-light ? nixos-artwork.wallpapers.nineish
, nixos-background-dark ? nixos-artwork.wallpapers.nineish-dark-gray
, extraGSettingsOverrides ? ""
, extraGSettingsOverridePackages ? []
}:

let
  inherit (lib) concatMapStringsSep;

  gsettingsOverrides = ''
    [org.gnome.desktop.background:Budgie]
    picture-uri="file://${nixos-background-light.gnomeFilePath}"
    picture-uri-dark="file://${nixos-background-dark.gnomeFilePath}"

    [org.gnome.desktop.screensaver:Budgie]
    picture-uri="file://${nixos-background-dark.gnomeFilePath}"

    [org.gnome.desktop.interface:Budgie]
    gtk-theme="Qogir"
    icon-theme="Qogir"
    cursor-theme="Qogir"
    font-name="Noto Sans 10"
    document-font-name="Noto Sans 10"
    monospace-font-name="Hack 10"

    [org.gnome.desktop.peripherals.touchpad:Budgie]
    tap-to-click=true

    [org.gnome.desktop.wm.preferences:Budgie]
    titlebar-font="Noto Sans Bold 10"

    [org.gnome.mutter:Budgie]
    edge-tiling=true

    [com.solus-project.budgie-menu:Budgie]
    use-default-menu-icon=true

    [com.solus-project.budgie-panel:Budgie]
    dark-theme=false
    builtin-theme=false

    [com.solus-project.icon-tasklist:Budgie]
    pinned-launchers=["nemo.desktop", "firefox.desktop", "vlc.desktop"]

    [org.buddiesofbudgie.budgie-desktop-view:Budgie]
    show=true
    show-active-mounts=true
    terminal="${mate.mate-terminal}/bin/mate-terminal"

    ${extraGSettingsOverrides}
  '';

  gsettingsOverridePackages = [
      budgie-desktop
      budgie-desktop-view
      gsettings-desktop-schemas
      magpie
  ] ++ extraGSettingsOverridePackages;

in
  runCommand "budgie-gsettings-overrides" { preferLocalBuild = true; } ''
    data_dir="$out/share/gsettings-schemas/nixos-gsettings-overrides"
    schema_dir="$data_dir/glib-2.0/schemas"
    mkdir -p "$schema_dir"

    ${concatMapStringsSep "\n" (pkg: "cp -rf \"${glib.getSchemaPath pkg}\"/*.xml \"${glib.getSchemaPath pkg}\"/*.gschema.override \"$schema_dir\"") gsettingsOverridePackages}

    chmod -R a+w "$data_dir"
    cat - > "$schema_dir/zz-nixos-defaults.gschema.override" <<- EOF
    ${gsettingsOverrides}
    EOF

    ${glib.dev}/bin/glib-compile-schemas --strict "$schema_dir"
  ''
