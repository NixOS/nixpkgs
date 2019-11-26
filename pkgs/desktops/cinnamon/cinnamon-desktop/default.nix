{ fetchFromGitHub, gdk_pixbuf, gobjectIntrospection, gtk3, intltool, meson, ninja, pkgconfig, pkgs, pulseaudio, python3, stdenv, xkeyboard_config, xorg }:

stdenv.mkDerivation rec {
  pname = "cinnamon-desktop";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-desktop";
    rev = "${version}";
    sha256 = "0bjqv3n417azjs2m1hlml6kw0rkax2fr22ym12n4l55fx3kl60p9";
  };

  buildInputs = [ gdk_pixbuf gobjectIntrospection gtk3 intltool pkgconfig pulseaudio xkeyboard_config xorg.libxkbfile ];
  nativeBuildInputs = [ meson ninja python3 ];

  postPatch = ''
    chmod +x install-scripts/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs install-scripts/meson_install_schemas.py
  '';
}
