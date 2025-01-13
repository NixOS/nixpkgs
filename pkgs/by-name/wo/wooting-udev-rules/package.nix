{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "wooting-udev-rules";
  version = "0-unstable-2024-11-20";

  # Source: https://help.wooting.io/article/147-configuring-device-access-for-wootility-under-linux-udev-rules
  src = [ ./wooting.rules ];

  dontUnpack = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-wooting.rules
  '';

  meta = with lib; {
    homepage = "https://help.wooting.io/article/147-configuring-device-access-for-wootility-under-linux-udev-rules";
    description = "udev rules that give NixOS permission to communicate with Wooting keyboards";
    platforms = platforms.linux;
    license = "unknown";
    maintainers = with maintainers; [
      davidtwco
      returntoreality
    ];
  };
}
