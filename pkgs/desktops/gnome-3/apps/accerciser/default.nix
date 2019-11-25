{ stdenv
, fetchurl
, pkgconfig
, gnome3
, gtk3
, wrapGAppsHook
, gobject-introspection
, itstool
, libxml2
, python3
, at-spi2-core
, dbus
, gettext
, libwnck3
, adwaita-icon-theme
}:

 python3.pkgs.buildPythonApplication rec {
  name = "accerciser-${version}";
  version = "3.34.2";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/accerciser/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1n6sy95j0r0v01sc9rbbpzikq2z4z42j8ah73hzmjdmck4iniik4";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection # For setup hook
    itstool
    libxml2
    pkgconfig
    dbus
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    at-spi2-core
    gtk3
    libwnck3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ipython
    pyatspi
    pycairo
    pygobject3
    setuptools
    xlib
  ];

  # Strict deps breaks accerciser
  # and https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

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
