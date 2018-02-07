{ stdenv, meson, ninja, gettext, fetchurl, atk
, pkgconfig, gtk3, glib, libsoup
, bash, itstool, libxml2, python3Packages
, gnome3, librsvg, gdk_pixbuf, file, libnotify, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 file wrapGAppsHook
  ];
  buildInputs = [
    gtk3 glib gnome3.gsettings_desktop_schemas
    gdk_pixbuf gnome3.defaultIconTheme librsvg
    libnotify gnome3.gnome_shell python3Packages.pygobject3
    libsoup gnome3.gnome_settings_daemon gnome3.nautilus
    gnome3.mutter gnome3.gnome_desktop gobjectIntrospection
  ];

  postPatch = ''
    patchShebangs meson-postinstall.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH")
  '';

  patches = [
    (fetchurl {
      name = "find_gsettings.patch";
      url = https://bugzilla.gnome.org/attachment.cgi?id=365642;
      sha256 = "14ik1kad0w99xa2wn3d4ynrkhnwchjlqfbaij7p11y5zpiwhaha4";
    })
    (fetchurl {
      name = "0001-Search-for-themes-and-icons-in-system-data-dirs.patch";
      url = https://bugzilla.gnome.org/attachment.cgi?id=365643;
      sha256 = "1phq3c7hc9lryih6rp3m5wmp88rfbl6iv42ng4g6bzm1jphgl89f";
    })
    (fetchurl {
      name = "0001-appearance-Don-t-duplicate-the-cursor-theme-name.patch";
      url = https://bugzilla.gnome.org/attachment.cgi?id=365648;
      sha256 = "1n9vwsfz4sx72qsi1gd1y7460zmagwirvmi9qrfhc3ahanpyn4fr";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/GnomeTweakTool;
    description = "A tool to customize advanced GNOME 3 options";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
