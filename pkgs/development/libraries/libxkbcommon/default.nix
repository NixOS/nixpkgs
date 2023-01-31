{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, bison
, doxygen
, xkeyboard_config
, libxcb
, libxml2
, python3
, libX11
  # To enable the "interactive-wayland" subcommand of xkbcli. This is the
  # wayland equivalent of `xev` on X11.
, withWaylandTools ? stdenv.isLinux
, wayland
, wayland-protocols
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "libxkbcommon";
  version = "1.5.0";

  src = fetchurl {
    url = "https://xkbcommon.org/download/${pname}-${version}.tar.xz";
    sha256 = "sha256-Vg8RxLu8oQ9JXz7306aqTKYrT4+wtS59RZ0Yom5G4Bc=";
  };

  outputs = [ "out" "dev" "doc" ];

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config bison doxygen ]
    ++ lib.optional withWaylandTools wayland-scanner;
  buildInputs = [ xkeyboard_config libxcb libxml2 ]
    ++ lib.optionals withWaylandTools [ wayland wayland-protocols ];
  nativeCheckInputs = [ python3 ];

  mesonFlags = [
    "-Dxkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "-Dxkb-config-extra-path=/etc/xkb" # default=$sysconfdir/xkb ($out/etc)
    "-Dx-locale-root=${libX11.out}/share/X11/locale"
    "-Denable-wayland=${lib.boolToString withWaylandTools}"
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
    mainProgram = "xkbcli";
    platforms = with platforms; unix;
  };
}
