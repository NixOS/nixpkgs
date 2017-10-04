{ stdenv, meson, ninja, gettext, fetchurl, atk
, pkgconfig, gtk3, glib, libsoup
, bash, itstool, libxml2, python3Packages
, gnome3, librsvg, gdk_pixbuf, file, libnotify, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  checkPhase = "meson test";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool libxml2 file wrapGAppsHook ];
  buildInputs = [ gtk3 glib gnome3.gsettings_desktop_schemas
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  libnotify gnome3.gnome_shell python3Packages.pygobject3
                  libsoup gnome3.gnome_settings_daemon gnome3.nautilus
                  gnome3.gnome_desktop gobjectIntrospection
                ];

  postPatch = ''
    patchShebangs meson-postinstall.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH")
  '';

  patches = [
    ./find_gsettings.patch
    ./0001-Search-for-themes-and-icons-in-system-data-dirs.patch
    ./0002-Don-t-show-multiple-entries-for-a-single-theme.patch
    ./0003-Create-config-dir-if-it-doesn-t-exist.patch
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/GnomeTweakTool;
    description = "A tool to customize advanced GNOME 3 options";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
