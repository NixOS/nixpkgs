{ lib, makeWrapper, symlinkJoin, thunar, thunarPlugins }:

symlinkJoin {
  name = "thunar-with-plugins-${thunar.version}";

  paths = [ thunar ] ++ thunarPlugins;

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
      substitute "${thunar}/$file" "$out/$file" \
        --replace "${thunar}" "$out"
    done
  '';

  meta = with lib; {
    inherit (thunar.meta) homepage license platforms maintainers;

    description = thunar.meta.description + optionalString
      (0 != length thunarPlugins)
      " (with plugins: ${concatStringsSep  ", " (map (x: x.name) thunarPlugins)})";
  };
}
