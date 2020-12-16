{ stdenv, fetchFromGitLab, writeText, cmake, doxygen, glslang, pkgconfig
, python3, SDL2, dbus, eigen, gst-plugins-base, gstreamer, hidapi, libXrandr
, libav, libjpeg, libsurvive, libusb1, libuv, opencv, openhmd, vulkan-headers
, vulkan-loader, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "monado";
  version = "0.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    rev = "v${version}";
    sha256 = "114aif79dqyn2qg07mkv6lzmqn15k6fdcii818rdf5g4bp7zzzgm";
  };

  nativeBuildInputs = [ cmake doxygen glslang pkgconfig python3 ];

  cmakeFlags = [ "-DXRT_BUILD_DRIVER_SURVIVE=On" ];

  buildInputs = [
    SDL2
    dbus
    eigen
    gst-plugins-base
    gstreamer
    hidapi
    libav
    libjpeg
    libsurvive
    libusb1
    libuv
    opencv
    openhmd
    vulkan-headers
    vulkan-loader
    wayland
    wayland-protocols
    libXrandr
  ];

  # Help openxr-loader find this runtime
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  meta = with stdenv.lib; {
    homepage = "https://gitlab.freedesktop.org/monado/monado";
    description = "An open source OpenXR runtime";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}
