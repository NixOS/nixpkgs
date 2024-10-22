{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  alsa-lib,
  gtk3,
  zlib,
  dbus,
  hidapi,
  libGL,
  libXcursor,
  libXext,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXScrnSaver,
  libXxf86vm,
  udev,
  vulkan-loader,
  wayland, # (not used by default, enable with SDL_VIDEODRIVER=wayland - doesn't support HiDPI)
  makeDesktopItem,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yarg";
  version = "0.12.6";

  src = fetchzip {
    url = "https://github.com/YARC-Official/YARG/releases/download/v${finalAttrs.version}/YARG_v${finalAttrs.version}-Linux-x86_64.zip";
    stripRoot = false;
    hash = "sha256-Za+CnuSTfJZVdW0pWvGDnKcbhZsgtNPRWYj1qOA8+Zs=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
    alsa-lib
    gtk3
    stdenv.cc.cc.lib
    zlib

    # Run-time libraries (loaded with dlopen)
    dbus
    hidapi
    libGL
    libXcursor
    libXext
    libXi
    libXinerama
    libxkbcommon
    libXrandr
    libXScrnSaver
    libXxf86vm
    udev
    vulkan-loader
    wayland
  ];

  desktopItem = makeDesktopItem {
    name = "yarg";
    desktopName = "YARG";
    comment = finalAttrs.meta.description;
    icon = "yarg";
    exec = "yarg";
    categories = [ "Game" ];
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 YARG "$out/bin/yarg"
    install -Dm644 UnityPlayer.so "$out/libexec/yarg/UnityPlayer.so"

    mkdir -p "$out/share/pixmaps"
    cp -r YARG_Data "$out/share/yarg"
    ln -s "$out/share/yarg" "$out/bin/yarg_Data"
    ln -s "$out/share/yarg/Resources/UnityPlayer.png" "$out/share/pixmaps/yarg.png"
    install -Dm644 "$desktopItem/share/applications/yarg.desktop" "$out/share/applications/yarg.desktop"

    runHook postInstall
  '';

  # Patch required run-time libraries as load-time libraries
  #
  # Libraries found with:
  # > strings UnityPlayer.so | grep '\.so'
  # and:
  # > LD_DEBUG=libs yarg
  postFixup = ''
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libdbus-1.so.3 \
      --add-needed libGL.so.1 \
      --add-needed libhidapi-hidraw.so.0 \
      --add-needed libpthread.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      "$out/libexec/yarg/UnityPlayer.so"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Free, open-source, plastic guitar game";
    homepage = "https://yarg.in";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" ];
  };
})
