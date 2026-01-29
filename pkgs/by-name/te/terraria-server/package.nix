{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  unzip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.5.3";
  urlVersion = lib.replaceStrings [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${urlVersion}.zip";
    hash = "sha256-5W6XpGaWQTs9lSy1UJq60YR6mfvb3LTts9ppK05XNCg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];
  buildInputs = [
    stdenv.cc.cc.libgcc
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer

    runHook postInstall
  '';

  # Starting with 1.4.5.1, the included build of SDL3 includes a .note.dlopen section,
  # which lists all the possible runtime dependencies. Since this is a headless server,
  # it doesn't actually need access to any of these libraries, but by default,
  # autoPatchelfHook will result in a build error if it doesn't find them.
  # This simply tells autoPatchelfHook to ignore these missing unused dependencies.
  autoPatchelfIgnoreMissingDeps = [
    "libusb-1.0.so.0"
    "libGLESv1_CM.so.1"
    "libGLES_CM.so.1"
    "libGLESv2.so.2"
    "libEGL.so.1"
    "libGL.so.1"
    "libasound.so.2"
    "libjack.so.0"
    "libpipewire-0.3.so.0"
    "libpulse.so.0"
    "libXtst.so.6"
    "libXss.so.1"
    "libXrandr.so.2"
    "libXfixes.so.3"
    "libXi.so.6"
    "libXcursor.so.1"
    "libXext.so.6"
    "libX11.so.6"
    "libX11-xcb.so.1"
    "libvulkan.so.1"
    "libdrm.so.2"
    "libdecor-0.so.0"
    "libxkbcommon.so.0"
    "libwayland-cursor.so.0"
    "libwayland-egl.so.1"
    "libwayland-client.so.0"
    "libfribidi.so.0"
    "libthai.so.0"
    "libdbus-1.so.3"
    "libudev.so.1"
    "libsteam_api.so"
  ];

  meta = {
    homepage = "https://terraria.org";
    description = "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    mainProgram = "TerrariaServer";
    maintainers = with lib.maintainers; [
      ncfavier
      tomasajt
    ];
  };
}
