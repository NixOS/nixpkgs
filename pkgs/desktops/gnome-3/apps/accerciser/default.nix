{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, itstool, libxml2, python3Packages, at-spi2-core
, dbus, intltool, libwnck3 }:

stdenv.mkDerivation rec {
  name = "accerciser-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "883306274442c7ecc076b24afca5190c835c40871ded1b9790da69347e9ca3c5";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook itstool intltool ];
  buildInputs = [
    gtk3 libxml2 python3Packages.python python3Packages.pyatspi
    python3Packages.pygobject3 python3Packages.ipython
    at-spi2-core dbus libwnck3 gnome3.defaultIconTheme
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "accerciser";
      attrPath = "gnome3.accerciser";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Accerciser;
    description = "Interactive Python accessibility explorer";
    maintainers = gnome3.maintainers;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
