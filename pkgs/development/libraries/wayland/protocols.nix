{ lib, stdenv, fetchurl, pkgconfig
, wayland
}:

stdenv.mkDerivation rec {
  name = "wayland-protocols-${version}";
  version = "1.18";

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1cvl93h83ymbfhb567jv5gzyq08181w7c46rsw4xqqqpcvkvfwrx";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ wayland ];

  meta = {
    description = "Wayland protocol extensions";
    homepage    = https://wayland.freedesktop.org/;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };

  passthru.version = version;
}
