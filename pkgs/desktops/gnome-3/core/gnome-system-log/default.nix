{ stdenv, intltool, fetchurl, pkgconfig
, bash, gtk3, glib, wrapGAppsHook
, itstool, gnome3, librsvg, gdk_pixbuf, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-system-log-3.9.90";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-system-log/3.9/${name}.tar.xz";
    sha256 = "9eeb51982d347aa7b33703031e2c1d8084201374665425cd62199649b29a5411";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ bash gtk3 glib intltool itstool
                  gnome3.gsettings-desktop-schemas wrapGAppsHook libxml2 ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3.out}/share:${gnome3.gnome-themes-standard}/share"
    )
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-system-log/3.9/;
    description = "Graphical, menu-driven viewer that you can use to view and monitor your system logs";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
