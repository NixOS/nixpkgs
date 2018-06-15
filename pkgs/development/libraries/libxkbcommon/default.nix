{ stdenv, fetchurl, fetchpatch, meson, ninja, pkgconfig, yacc, xkeyboard_config, libxcb, libX11, doxygen }:

stdenv.mkDerivation rec {
  name = "libxkbcommon-0.8.0";

  src = fetchurl {
    url = "https://xkbcommon.org/download/${name}.tar.xz";
    sha256 = "0vgy84vfbig5bqznr137h5arjidnfwrxrdli0pxyn2jfn1fjcag8";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ meson ninja pkgconfig yacc doxygen ];
  buildInputs = [ xkeyboard_config libxcb ];

  patches = [
    # darwin compatibility
    (fetchpatch {
      url = https://github.com/xkbcommon/libxkbcommon/commit/edb1c662394578a54b7bbed231d918925e5d8150.patch;
      sha256 = "0ydjlir32r3xfsbqhnsx1bz6ags2m908yhf9i09i1s7sgcimbcx5";
    })
  ];

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
    maintainers = with maintainers; [ garbas ttuegel ];
    platforms = with platforms; unix;
  };
}
