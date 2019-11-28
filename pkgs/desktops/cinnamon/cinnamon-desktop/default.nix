{ fetchFromGitHub, gdk_pixbuf, gobject-introspection, gtk3, intltool, meson, ninja, pkgconfig, pkgs, pulseaudio, python3, stdenv, xkeyboard_config, xorg, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "cinnamon-desktop";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0bjqv3n417azjs2m1hlml6kw0rkax2fr22ym12n4l55fx3kl60p9";
  };

  buildInputs = [ gdk_pixbuf gtk3 intltool pkgconfig pulseaudio xkeyboard_config xorg.libxkbfile ];
  nativeBuildInputs = [ meson gobject-introspection ninja python3 wrapGAppsHook ];

  postPatch = ''
    chmod +x install-scripts/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs install-scripts/meson_install_schemas.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/cinnamon-desktop";
    description = "Library and data for various Cinnamon modules";

    longDescription = ''
       The libcinnamon-desktop library provides API shared by several applications
       on the desktop, but that cannot live in the platform for various
       reasons. There is no API or ABI guarantee, although we are doing our
       best to provide stability. Documentation for the API is available with
       gtk-doc.
    '';

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
