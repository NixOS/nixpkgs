{
  addDriverRunpath,
  autoPatchelfHook,
  dbus,
  dpkg,
  fetchurl,
  lib,
  libGL,
  libxkbcommon,
  makeBinaryWrapper,
  stdenv,
  udev,
  ultraleap-hand-tracking-service,
  vulkan-loader,
  wayland,
  xorg,
  zlib,
}:
stdenv.mkDerivation {
  pname = "ultraleap-hand-tracking-control-panel";
  version = "3.4.1";

  src = fetchurl {
    url = "https://repo.ultraleap.com/apt/pool/main/u/ultraleap-hand-tracking-control-panel/ultraleap-hand-tracking-control-panel_1125862.deb";
    hash = "sha256-Pli0ENEtzBQGvfo2nIf09b62Xt3gzML/QYXMwtrD+7Y=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = [
    dbus
    libGL
    libxkbcommon
    stdenv.cc.cc
    udev
    ultraleap-hand-tracking-service
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
    zlib
  ];

  strictDeps = true;

  dontBuild = true;

  runtimeDependencies = [
    "libGL.so.1"
    "libLeapC.so"
    "libX11.so.6"
    "libXcursor.so.1"
    "libXext.so.6"
    "libXi.so.6"
    "libXinerama.so.1"
    "libXrandr.so.2"
    "libXss.so.1"
    "libXxf86vm.so.1"
    "libdbus-1.so.3"
    "libudev.so.1"
    "libvulkan.so.1"
    "libwayland-client.so.0"
    "libwayland-cursor.so.0"
    "libwayland-egl.so.1"
    "libxkbcommon.so.0"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/opt
    cp -Tr usr/share $out/share
    cp -Tr opt $out/opt

    makeWrapper $out/opt/ultraleap-hand-tracking-control-panel/ultraleap-hand-tracking-control-panel $out/bin/ultraleap-hand-tracking-control-panel \
      --prefix LD_LIBRARY_PATH : "${addDriverRunpath.driverLink}/lib"

    runHook postInstall
  '';

  meta = {
    description = "Ultraleap Hand Tracking control panel";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      Scrumplex
      pandapip1
    ];
    mainProgram = "ultraleap-hand-tracking-control-panel";
  };
}
