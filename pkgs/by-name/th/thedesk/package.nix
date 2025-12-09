{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  gtk3,
  libxshmfence,
  libgbm,
  libGL,
  musl,
  nss,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thedesk";
  version = "25.2.2";

  src = fetchurl {
    url = "https://github.com/cutls/thedesk-next/releases/download/v${finalAttrs.version}/thedesk-next_${finalAttrs.version}_amd64.deb";
    hash = "sha256-9Xd0YHkFHPVY6BHy0V1X7p27m2iJFVHmSickzMJeOXs=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libgbm
    libGL
    libxshmfence
    musl
    nss
  ];

  runtimeDependencies = [ systemd ];

  installPhase = ''
    runHook preInstall

    substituteInPlace usr/share/applications/thedesk-next.desktop \
      --replace-fail "/opt/TheDesk/thedesk-next" "thedesk"
    cp --recursive usr $out
    mkdir $out/libexec $out/bin
    cp --recursive opt/TheDesk $out/libexec/thedesk
    ln --symbolic $out/libexec/thedesk/thedesk-next $out/bin/thedesk

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libGL.so.1 $out/libexec/thedesk/thedesk-next
  '';

  meta = {
    description = "Mastodon/Misskey Client for PC";
    homepage = "https://thedesk.top";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "thedesk";
  };
})
