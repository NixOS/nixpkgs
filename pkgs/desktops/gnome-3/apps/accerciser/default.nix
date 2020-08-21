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
  pname = "accerciser";
  version = "3.38.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fd9vv2abd2if2qj4nlfy7mpd7rc4sx18zhmxd5ijlnfhkpggbp5";
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
    homepage = "https://wiki.gnome.org/Apps/Accerciser";
    description = "Interactive Python accessibility explorer";
    maintainers = teams.gnome.members;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
