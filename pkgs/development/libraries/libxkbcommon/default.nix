{ stdenv, fetchurl, fetchpatch, meson, ninja, pkgconfig, yacc, xkeyboard_config, libxcb, libX11, doxygen }:

stdenv.mkDerivation rec {
  pname = "libxkbcommon";
  version = "0.10.0";

  src = fetchurl {
    url = "https://xkbcommon.org/download/${pname}-${version}.tar.xz";
    sha256 = "1wmnl0hngn6vrqrya4r8hvimlkr4jag39yjprls4gyrqvh667hsp";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ meson ninja pkgconfig yacc doxygen ];
  buildInputs = [ xkeyboard_config libxcb ];

  mesonFlags = [
    "-Denable-wayland=false"
    "-Dxkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "-Dx-locale-root=${libX11.out}/share/X11/locale"
  ];

  doCheck = false; # fails, needs unicode locale

  meta = with stdenv.lib; {
    description = "A library to handle keyboard descriptions";
    homepage = https://xkbcommon.org;
    license = licenses.mit;
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; unix;
  };
}
