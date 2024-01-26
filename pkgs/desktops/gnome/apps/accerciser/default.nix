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
, librsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "accerciser";
  version = "3.42.0";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "d2m9T09j3ImhQ+hs3ET+rr1/jJab6lwfWoaskxGQL0g=";
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
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ipython
    pyatspi
    pycairo
    pygobject3
    setuptools
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

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
