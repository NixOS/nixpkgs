{ lib, stdenv, fetchurl, meson, ninja, pkg-config, bison, doxygen
, xkeyboard_config, libxcb, libxml2
, python3
, libX11
# To enable the "interactive-wayland" subcommand of xkbcli:
, withWaylandSupport ? false, wayland, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "libxkbcommon";
  version = "1.2.1";

  src = fetchurl {
    url = "https://xkbcommon.org/download/${pname}-${version}.tar.xz";
    sha256 = "1cqzd4vd5jw3ghibmdqvy90mb1h8vvazc81bxgavk6sc0b9sfcz8";
  };

  outputs = [ "out" "dev" "doc" ];

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config bison doxygen ]
    ++ lib.optional withWaylandSupport wayland;
  buildInputs = [ xkeyboard_config libxcb libxml2 ]
    ++ lib.optionals withWaylandSupport [ wayland wayland-protocols ];
  checkInputs = [ python3 ];

  mesonFlags = [
    "-Dxkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "-Dxkb-config-extra-path=/etc/xkb" # default=$sysconfdir/xkb ($out/etc)
    "-Dx-locale-root=${libX11.out}/share/X11/locale"
    "-Denable-wayland=${lib.boolToString withWaylandSupport}"
  ];

  doCheck = true;
  preCheck = ''
    patchShebangs ../test/
  '';

  meta = with lib; {
    description = "A library to handle keyboard descriptions";
    longDescription = ''
      libxkbcommon is a keyboard keymap compiler and support library which
      processes a reduced subset of keymaps as defined by the XKB (X Keyboard
      Extension) specification. It also contains a module for handling Compose
      and dead keys.
    ''; # and a separate library for listing available keyboard layouts.
    homepage = "https://xkbcommon.org";
    changelog = "https://github.com/xkbcommon/libxkbcommon/blob/xkbcommon-${version}/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ primeos ttuegel ];
    platforms = with platforms; unix;
  };
}
