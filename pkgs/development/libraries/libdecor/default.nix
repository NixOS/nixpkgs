{ stdenv
, lib
, fetchFromGitLab
, pkg-config
, meson
, ninja
, wayland
, wayland-protocols
, wayland-scanner
, cairo
, dbus
, pango
}:

stdenv.mkDerivation rec {
  pname = "libdecor";
  version = "0.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libdecor";
    repo = "libdecor";
<<<<<<< HEAD
    rev = version;
=======
    rev = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hash = "sha256-8b6qCqOSDDbhYwAeAaUyI71tSopTkGtCJaxZaJw1vQQ=";
  };

  outputs = [ "out" "dev" ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "demo" false)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cairo
    dbus
    pango
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/libdecor/libdecor";
    description = "Client-side decorations library for Wayland clients";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
