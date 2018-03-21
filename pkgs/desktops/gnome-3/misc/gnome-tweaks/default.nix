{ stdenv, meson, ninja, gettext, fetchurl, atk
, pkgconfig, gtk3, glib, libsoup
, bash, itstool, libxml2, python3Packages
, gnome3, librsvg, gdk_pixbuf, file, libnotify, gobjectIntrospection, wrapGAppsHook }:

let
  pname = "gnome-tweaks";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0d8zxfa8r4n4l6jzyzy6q58padxjlrad3c71mwqidm2ww8nm6i19";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 wrapGAppsHook
  ];
  buildInputs = [
    gtk3 glib gnome3.gsettings-desktop-schemas
    gdk_pixbuf gnome3.defaultIconTheme
    libnotify gnome3.gnome-shell python3Packages.pygobject3
    libsoup gnome3.gnome-settings-daemon gnome3.nautilus
    gnome3.mutter gnome3.gnome-desktop gobjectIntrospection
    gnome3.nautilus
  ];

  postPatch = ''
    patchShebangs meson-postinstall.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/GnomeTweakTool;
    description = "A tool to customize advanced GNOME 3 options";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
