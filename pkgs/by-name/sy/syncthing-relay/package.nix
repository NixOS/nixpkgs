{
  lib,
  stdenv,
  syncthing,
}:

(syncthing.override {
  target = "strelaysrv";
}).overrideAttrs
  {
    pname = "syncthing-relay";
    postInstall = lib.optionalString (stdenv.hostPlatform.isLinux) ''
      mkdir -p $out/lib/systemd/system

      substitute cmd/strelaysrv/etc/linux-systemd/strelaysrv.service \
                 $out/lib/systemd/system/strelaysrv.service \
                 --replace-fail /usr/bin/strelaysrv $out/bin/strelaysrv
    '';
  }
