{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, wayland
, gtk3
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gtk-layer-shell";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "wmww";
    repo = "gtk-layer-shell";
    rev = "v${version}";
    sha256 = "1fwvlbwp5w1zly6mksvlzbx18ikq4bh7pdj9q0k94qlj6x2zdwg8";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
  ];

  buildInputs = [
    wayland gtk3 gobject-introspection
  ];

  mesonFlags = [
    "-Dout=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "A library to create panels and other desktop components for Wayland using the Layer Shell protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ eonpatapon ];
    platforms = platforms.unix;
  };
}
