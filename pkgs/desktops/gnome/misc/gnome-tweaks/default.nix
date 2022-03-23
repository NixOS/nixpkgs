{ lib
, meson
, ninja
, fetchurl
, gdk-pixbuf
, gettext
, glib
, gnome
, gobject-introspection
, gsettings-desktop-schemas
, gtk3
, itstool
, libhandy
, libnotify
, libsoup
, libxml2
, pkg-config
, python3Packages
, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "gnome-tweaks";
  version = "40.10";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "z/07M6OZV3+7RJHOj70C9UxZJPEFbzARTo1CApDvI/w=";
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
    gnome.gnome-desktop
    gnome.gnome-settings-daemon
    gnome.gnome-shell
    # Makes it possible to select user themes through the `user-theme` extension
    gnome.gnome-shell-extensions
    gnome.mutter
    gsettings-desktop-schemas
    gtk3
    libhandy
    libnotify
    libsoup
  ];

  pythonPath = with python3Packages; [
    pygobject3
  ];

  postPatch = ''
    patchShebangs meson-postinstall.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Tweaks";
    description = "A tool to customize advanced GNOME 3 options";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
