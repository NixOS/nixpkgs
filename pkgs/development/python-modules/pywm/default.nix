{ lib,
fetchFromGitHub,
python3Packages,
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
mesa,
pixman,
seatd,
vulkan-loader,
xorg,
libpng,
libcap,
ffmpeg,
xwayland
}:

python3Packages.buildPythonPackage rec {
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
    mesa
    seatd
    xwayland
    vulkan-loader

    libpng
    ffmpeg
    libcap
  ];

  propagatedBuildInputs = [
    python3Packages.imageio
    python3Packages.numpy
    python3Packages.pycairo
    python3Packages.evdev
    python3Packages.matplotlib
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
