{ stdenv, intltool, fetchurl, pkgconfig
, gtk3, glib, wrapGAppsHook
, itstool, gnome3, libxml2 }:

let
  pname = "gnome-system-log";
  version = "3.9.90";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "9eeb51982d347aa7b33703031e2c1d8084201374665425cd62199649b29a5411";
  };

  doCheck = true;

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook libxml2 ];
  buildInputs = [ gtk3 glib gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Graphical, menu-driven viewer that you can use to view and monitor your system logs";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
