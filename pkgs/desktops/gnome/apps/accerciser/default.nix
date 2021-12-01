{ lib
, fetchurl
, pkg-config
, gnome
, gtk3
, wrapGAppsHook
, gobject-introspection
, itstool
, libxml2
, python3
, at-spi2-core
, dbus
, gettext
, libwnck
, adwaita-icon-theme
}:

python3.pkgs.buildPythonApplication rec {
  pname = "accerciser";
  version = "3.38.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fd9vv2abd2if2qj4nlfy7mpd7rc4sx18zhmxd5ijlnfhkpggbp5";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection # For setup hook
    itstool
    libxml2
    pkg-config
    dbus
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    at-spi2-core
    gtk3
    libwnck
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
    updateScript = gnome.updateScript {
      packageName = "accerciser";
      attrPath = "gnome.accerciser";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Accerciser";
    description = "Interactive Python accessibility explorer";
    maintainers = teams.gnome.members;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
