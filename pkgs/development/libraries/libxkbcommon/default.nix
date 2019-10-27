{ stdenv, fetchurl, fetchpatch, meson, ninja, pkgconfig, yacc, xkeyboard_config, libxcb, libX11, doxygen }:

stdenv.mkDerivation rec {
  pname = "libxkbcommon";
  version = "0.8.4";

  src = fetchurl {
    url = "https://xkbcommon.org/download/${pname}-${version}.tar.xz";
    sha256 = "12vc91ydhphd5sddz15560r41l7k0i7mq6nma8kkbzdp6bwwzpb0";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ meson ninja pkgconfig yacc doxygen ];
  buildInputs = [ xkeyboard_config libxcb ];

  mesonFlags = [
    "-Denable-wayland=false"
    "-Dxkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "-Dx-locale-root=${libX11.out}/share/X11/locale"
  ];

  patches = stdenv.lib.optionals stdenv.isDarwin [
    # Fix build on darwin
    (fetchpatch {
      url = "https://github.com/xkbcommon/libxkbcommon/commit/32d178b50fe0da05e51e4fe8903c84371d133331.patch";
      sha256 = "1wqdjla8hmgdqr8xc2manw363sxrqqsn3s8bd397h3cd7fj3hh1v";
    })
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
