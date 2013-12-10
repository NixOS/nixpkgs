{ stdenv, fetchurl, pkgconfig, autoreconfHook, intltool
, glib, gobjectIntrospection, gdk_pixbuf, gtk3, gnome_common
, xorg, xkeyboard_config
}:

let
  version = "2.0.4";
in
stdenv.mkDerivation {
  name = "cinnamon-desktop-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-desktop/archive/${version}.tar.gz";
    sha256 = "1cywin712558pv58c0cr73m25hfcv5x8pv5frvqjr9gwr2gpi6h3";
  };

  NIX_CFLAGS_COMPILE = "-I${glib}/include/gio-unix-2.0";

  buildInputs = with xorg; [
    pkgconfig autoreconfHook intltool
    glib gobjectIntrospection gdk_pixbuf gtk3 gnome_common
    xkeyboard_config libxkbfile libX11 libXrandr libXext
  ];

  postInstall  = ''
    ${glib}/bin/glib-compile-schemas $out/share/glib-2.0/schemas/
  '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "Library and data for various Cinnamon modules";

    longDescription = ''
       The libcinnamon-desktop library provides API shared by several applications
       on the desktop, but that cannot live in the platform for various
       reasons. There is no API or ABI guarantee, although we are doing our
       best to provide stability. Documentation for the API is available with
       gtk-doc.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}

