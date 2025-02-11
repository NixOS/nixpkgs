{
  lib,
  stdenv,
  fetchFromSourcehut,
  meson,
  ninja,
  cmake,
  pkg-config,
  wayland-scanner,
  wayland-protocols,
  wayland,
  cairo,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "wlclock";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wlclock";
    rev = "v${version}";
    sha256 = "sha256-aHA4kXHYH+KvAJSep5X3DqsiK6WFpXr3rGQl/KNiUcY=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    wayland-protocols
    wayland
    cairo
  ];

  meta = with lib; {
    description = "Digital analog clock for Wayland desktops";
    homepage = "https://git.sr.ht/~leon_plickat/wlclock";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nomisiv ];
    platforms = with platforms; linux;
    mainProgram = "wlclock";
  };
}
