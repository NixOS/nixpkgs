{ lib
, runCommand
, gsettings-desktop-schemas
, mate-wayland-session
, glib
}:

let
  gsettingsOverridePackages = [
    gsettings-desktop-schemas
    mate-wayland-session
  ];
in
runCommand "mate-gsettings-overrides" { preferLocalBuild = true; } ''
  data_dir="$out/share/gsettings-schemas/nixos-gsettings-overrides"
  schema_dir="$data_dir/glib-2.0/schemas"
  mkdir -p "$schema_dir"

  ${lib.concatMapStringsSep "\n" (pkg: "cp -rf \"${glib.getSchemaPath pkg}\"/*.xml \"${glib.getSchemaPath pkg}\"/*.gschema.override \"$schema_dir\"") gsettingsOverridePackages}

  chmod -R a+w "$data_dir"

  ${glib.dev}/bin/glib-compile-schemas --strict "$schema_dir"
''
