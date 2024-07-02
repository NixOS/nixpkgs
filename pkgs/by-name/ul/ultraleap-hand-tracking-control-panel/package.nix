{ addOpenGLRunpath
, autoPatchelfHook
, dbus
, dpkg
, fetchurl
, lib
, libGL
, libxkbcommon
, makeWrapper
, stdenv
, udev
, ultraleap-hand-tracking-service
, vulkan-loader
, wayland
, xorg
, zlib
}:
stdenv.mkDerivation {
  pname = "ultraleap-hand-tracking-control-panel";
  version = "3.4.1";

  src = fetchurl {
    url = "https://repo.ultraleap.com/apt/pool/main/u/ultraleap-hand-tracking-control-panel/ultraleap-hand-tracking-control-panel_1125862.deb";
    hash = "sha256-Pli0ENEtzBQGvfo2nIf09b62Xt3gzML/QYXMwtrD+7Y=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg makeWrapper ];
  buildInputs = [
    dbus
    libGL
    libxkbcommon
    stdenv.cc.cc.lib
    udev
    ultraleap-hand-tracking-service
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXext
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXi
    xorg.libXrandr
    xorg.libXScrnSaver
    xorg.libXxf86vm
    zlib
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/opt
    cp -Tr usr/share $out/share
    cp -Tr opt $out/opt

    makeWrapper $out/opt/ultraleap-hand-tracking-control-panel/ultraleap-hand-tracking-control-panel $out/bin/ultraleap-hand-tracking-control-panel \
      --prefix LD_LIBRARY_PATH : "${addOpenGLRunpath.driverLink}/lib"

    patchelf $out/opt/ultraleap-hand-tracking-control-panel/ultraleap-hand-tracking-control-panel \
      --add-needed "libdbus-1.so.3" \
      --add-needed "libGL.so.1" \
      --add-needed "libLeapC.so" \
      --add-needed "libudev.so.1" \
      --add-needed "libvulkan.so.1" \
      --add-needed "libwayland-client.so.0" \
      --add-needed "libwayland-cursor.so.0" \
      --add-needed "libwayland-egl.so.1" \
      --add-needed "libX11.so.6" \
      --add-needed "libXcursor.so.1" \
      --add-needed "libXext.so.6" \
      --add-needed "libXi.so.6" \
      --add-needed "libXinerama.so.1" \
      --add-needed "libXrandr.so.2" \
      --add-needed "libXss.so.1" \
      --add-needed "libXxf86vm.so.1" \
      --add-needed "libxkbcommon.so.0"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Ultraleap Hand Tracking control panel";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Scrumplex pandapip1 ];
  };
}
