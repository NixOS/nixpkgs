{
  stdenv,
  fetchFromGitHub,
  multimarkdown,
  libnotify,
  udev,
  systemdLibs,
  glib,
  pkg-config,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "udev-block-notify";
  version = "0.7.11";

  src = fetchFromGitHub {
    owner = "eworm-de";
    repo = "udev-block-notify";
    tag = finalAttrs.version;
    hash = "sha256-A0uhfb2mEAAJgxRkv+MWTk/9oFiz3r7deAlu1Kpk+CI=";
  };

  nativeBuildInputs = [
    multimarkdown
    pkg-config
  ];
  buildInputs = [
    libnotify
    udev
    systemdLibs
    glib
  ];

  installPhase = ''
    runHook preInstall

    substituteInPlace systemd/udev-block-notify.service \
      --replace-fail '/usr/bin/udev-block-notify' "$out/bin/udev-block-notify"

    install -D -m0755 udev-block-notify $out/bin/udev-block-notify
    install -D -m0644 systemd/udev-block-notify.service $out/lib/systemd/user/udev-block-notify.service

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/eworm-de/udev-block-notify";
    description = "Notify about udev block events";
    mainProgram = "udev-block-notify";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ danbulant ];
    platforms = lib.platforms.linux;
  };
})
