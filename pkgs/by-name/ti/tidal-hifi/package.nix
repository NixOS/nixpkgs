{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, makeWrapper
, wrapGAppsHook3
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, ffmpeg
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libappindicator-gtk3
, libdbusmenu
, libdrm
, libnotify
, libpulseaudio
, libsecret
, libuuid
, libxkbcommon
, libgbm
, nss
, pango
, systemd
, xdg-utils
, xorg
, libGL
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tidal-hifi";
  version = "5.17.0";

  src = fetchurl {
    url = "https://github.com/Mastermindzh/tidal-hifi/releases/download/${finalAttrs.version}/tidal-hifi_${finalAttrs.version}_amd64.deb";
    sha256 = "sha256-oM0hXimXSrV33tntV+DeYdV0WyyRqioKSm+rL+Oce6Y=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg makeWrapper wrapGAppsHook3 ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    pango
    systemd
    libgbm
    nss
    libuuid
    libdrm
    libnotify
    libsecret
    libpulseaudio
    libxkbcommon
    libappindicator-gtk3
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
    libGL
  ];

  runtimeDependencies =
    [ (lib.getLib systemd) libnotify libdbusmenu xdg-utils ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/tidal-hifi/tidal-hifi $out/bin/tidal-hifi \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      "''${gappsWrapperArgs[@]}"
    substituteInPlace $out/share/applications/tidal-hifi.desktop \
      --replace "/opt/tidal-hifi/tidal-hifi" "tidal-hifi"
  '';

  meta = {
    changelog = "https://github.com/Mastermindzh/tidal-hifi/releases/tag/${finalAttrs.version}";
    description = "Web version of Tidal running in electron with hifi support thanks to widevine";
    homepage = "https://github.com/Mastermindzh/tidal-hifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbit spikespaz ];
    platforms = lib.platforms.linux;
    mainProgram = "tidal-hifi";
  };
})
