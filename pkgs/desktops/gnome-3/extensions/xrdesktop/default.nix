{ fetchgit
, stdenv
, meson
, ninja
, cmake
, pkgconfig
, gobject-introspection
, xrdesktop
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-xrdesktop";
  version = "3.34.0-xrdesktop-${xrdesktop.version}"; # TODO: use major.minor.0 from gnome-shell ?

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/xrdesktop/gnome-shell-extension-xrdesktop.git";
    rev = version;
    sha256 = "18gyhq1lpg5kxljb9wa3xkikrpfqfsiy7lzlxk93f23xbx8gqkwp";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkgconfig
    gobject-introspection
  ];
}
