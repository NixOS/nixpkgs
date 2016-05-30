{ lib, stdenv, fetchurl, pkgconfig
, wayland
}:

stdenv.mkDerivation rec {
  name = "wayland-protocols-${version}";
  version = "1.4";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0wpm7mz7ww6nn3vrgz7a9iyk7mk6za73wnq0n54lzl8yq8irljh1";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ wayland ];

  meta = {
    description = "Wayland protocol extensions";
    homepage    = http://wayland.freedesktop.org/;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };

  passthru.version = version;
}
