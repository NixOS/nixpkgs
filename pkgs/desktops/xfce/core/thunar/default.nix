{ lib
, makeWrapper
, callPackage
, symlinkJoin
, base ? callPackage ./base.nix {}
, thunarPlugins ? []
}:


if thunarPlugins == [] then base
else symlinkJoin {

  name = "thunar-with-plugins-${base.version}";

  paths = [ base ] ++ thunarPlugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/thunar" \
      --set "THUNARX_DIRS" "$out/lib/thunarx-3"

    wrapProgram "$out/bin/thunar-settings" \
      --set "THUNARX_DIRS" "$out/lib/thunarx-3"

    # NOTE: we need to remove the folder symlink itself and create
    # a new folder before trying to substitute any file below.
    rm -f "$out/lib/systemd/user"
    mkdir -p "$out/lib/systemd/user"

    # point to wrapped binary in all service files
    for file in "lib/systemd/user/thunar.service" \
      "share/dbus-1/services/org.xfce.FileManager.service" \
      "share/dbus-1/services/org.xfce.Thunar.FileManager1.service" \
      "share/dbus-1/services/org.xfce.Thunar.service"
    do
      rm -f "$out/$file"
      substitute "${base}/$file" "$out/$file" \
        --replace "${base}" "$out"
    done
  '';

  meta = with lib; {
    inherit (base.meta) homepage license platforms maintainers;

    description = base.meta.description + optionalString
      (0 != length thunarPlugins)
      " (with plugins: ${concatStringsSep  ", " (map (x: x.name) thunarPlugins)})";
  };
}
