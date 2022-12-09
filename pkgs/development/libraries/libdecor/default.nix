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
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jadahl";
    repo = "libdecor";
    rev = "${version}";
    sha256 = "0qdg3r7k086wzszr969s0ljlqdvfqm31zpl8p5h397bw076zr6p2";
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
    homepage = "https://gitlab.gnome.org/jadahl/libdecor";
    description = "Client-side decorations library for Wayland clients";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
