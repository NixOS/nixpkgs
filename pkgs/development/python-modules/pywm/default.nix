{ lib,
pkgs,
buildPythonPackage,
fetchFromGitHub,
meson_0_60,
ninja,
pkg-config,
wayland-scanner,
glslang,
libGL,
wayland,
wayland-protocols,
libinput,
libxkbcommon,
pixman,
seatd,
vulkan-loader,
xorg,
libpng,
libcap,
ffmpeg,
xwayland,

imageio,
numpy,
pycairo,
evdev,
matplotlib
}:

buildPythonPackage rec {
  pname = "pywm";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jbuchermn";
    repo = "pywm";
    fetchSubmodules = true;
    rev = "89f8de6";
    sha256= "sha256-UOBlV/I3f9XLHeKnF9EOYN7XpcHDpNC01mvRHOWJ4TQ=";
  };

  nativeBuildInputs = [
    meson_0_60
    ninja
    pkg-config
    wayland-scanner
    glslang
  ];

  preBuild = "cd ..";

  buildInputs = [
    libGL
    wayland
    wayland-protocols
    libinput
    libxkbcommon
    pixman
    xorg.xcbutilwm
    xorg.xcbutilrenderutil
    xorg.xcbutilerrors
    xorg.xcbutilimage
    xorg.libX11
    seatd
    xwayland
    vulkan-loader
    pkgs.mesa # Prevent clash with python module mesa

    libpng
    ffmpeg
    libcap
  ];

  propagatedBuildInputs = [
    imageio
    numpy
    pycairo
    evdev
    matplotlib
  ];

  LC_ALL = "en_US.UTF-8";

  meta =  with lib; {
    description = "Wayland compositor core";
    longDescription = ''
      Python based Wayland compositor library based on wlroots.
      Backend for the compositor newm.
    '';
    homepage = "https://github.com/jbuchermn/pywm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jbuchermn ];
  };
}
