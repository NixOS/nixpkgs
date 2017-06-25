{ stdenv, intltool, fetchurl, atk
, pkgconfig, gtk3, glib, libsoup
, bash, makeWrapper, itstool, libxml2, python2Packages
, gnome3, librsvg, gdk_pixbuf, file, libnotify, gobjectIntrospection, wrapGAppsHook }:

let
  pythonEnv = python2Packages.python.withPackages ( ps: with ps; [ pygobject3 ] );
in stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  makeFlags = [ "DESTDIR=/" ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2
                  gnome3.gsettings_desktop_schemas makeWrapper file
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  libnotify gnome3.gnome_shell
                  libsoup gnome3.gnome_settings_daemon gnome3.nautilus
                  gnome3.gnome_desktop wrapGAppsHook
                  python2Packages.pygobject3.dev pythonEnv gobjectIntrospection ];

  PYTHONPATH = "$out/${pythonEnv.python.sitePackages}";

  wrapPrefixVariables = [ "PYTHONPATH" ];

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
