{ symlinkJoin
, tuxclocker-nvidia-plugin
, tuxclocker-plugins
}:

symlinkJoin rec {
  inherit (tuxclocker-plugins) version meta;

  pname = "tuxclocker-plugins-with-unfree";
  name = "${pname}-${version}";

  paths = [
    tuxclocker-nvidia-plugin
    tuxclocker-plugins
  ];
}
