{ stdenvNoCC
, libu2f-host
}:

stdenvNoCC.mkDerivation {
  pname = "libu2f-host-udev-rules";

  inherit (libu2f-host) version src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d/
    cp *.rules $out/etc/udev/rules.d/
  '';

  meta = libu2f-host.meta // {
    Description = "Yubikey udev rules";
  };
}
