{ stdenv
, lib
, fetchFromGitLab
, pkg-config
, meson
, ninja
, wayland
, wayland-protocols
, wayland-scanner
, egl-wayland
, cairo
, dbus
, pango
, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "libdecor";
  version = "0.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libdecor";
    repo = "libdecor";
    rev = "${version}";
    hash = "sha256-8b6qCqOSDDbhYwAeAaUyI71tSopTkGtCJaxZaJw1vQQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    egl-wayland
    cairo
    dbus
    pango
    libxkbcommon
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/libdecor/libdecor";
    description = "Client-side decorations library for Wayland clients";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
