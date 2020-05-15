{ makeWrapper, symlinkJoin, thunar, thunarPlugins, lib }:

symlinkJoin {
  name = "thunar-with-plugins-${thunar.version}";

  paths = [ thunar ] ++ thunarPlugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/thunar" \
      --set "THUNARX_MODULE_DIR" "$out/lib/thunarx-3"

    wrapProgram "$out/bin/thunar-settings" \
      --set "THUNARX_MODULE_DIR" "$out/lib/thunarx-3"

    for file in "lib/systemd/user/thunar.service" "share/dbus-1/services/org.xfce.FileManager.service" \
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
      " (with plugins: ${concatStrings (intersperse ", " (map (x: x.name) thunarPlugins))})";
  };
}
