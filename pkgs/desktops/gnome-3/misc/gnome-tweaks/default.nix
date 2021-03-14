{ lib
, meson
, ninja
, fetchurl
, gdk-pixbuf
, gettext
, glib
, gnome3
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, itstool
, libhandy_0
, libnotify
, libsoup
, libxml2
, pkg-config
, python3Packages
, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "gnome-tweaks";
  version = "3.34.1";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19y62dj4n5i6v4zpjllxl51dch6ndy8xs45v5aqmmq9xyfrqk5yq";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    itstool
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gnome3.gnome-desktop
    gnome3.gnome-settings-daemon
    gnome3.gnome-shell
    # Makes it possible to select user themes through the `user-theme` extension
    gnome3.gnome-shell-extensions
    gnome3.mutter
    gsettings-desktop-schemas
    gtk3
    libhandy_0
    libnotify
    libsoup
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  postPatch = ''
    patchShebangs meson-postinstall.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/action/show/Apps/GnomeTweakTool";
    description = "A tool to customize advanced GNOME 3 options";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
