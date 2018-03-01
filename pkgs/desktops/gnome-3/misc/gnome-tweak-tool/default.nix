{ stdenv, meson, ninja, gettext, fetchurl, atk
, pkgconfig, gtk3, glib, libsoup
, bash, itstool, libxml2, python3Packages
, gnome3, librsvg, gdk_pixbuf, file, libnotify, gobjectIntrospection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gnome-tweak-tool-${version}";
  version = "3.26.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tweak-tool/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "fda08044d22c258bbd93dbad326d282d4d1184b98795ae8e3e5f07f8275005df";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-tweak-tool"; attrPath = "gnome3.gnome-tweak-tool"; };
  };

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxml2 file wrapGAppsHook
  ];
  buildInputs = [
    gtk3 glib gnome3.gsettings-desktop-schemas
    gdk_pixbuf gnome3.defaultIconTheme librsvg
    libnotify gnome3.gnome-shell python3Packages.pygobject3
    libsoup gnome3.gnome-settings-daemon gnome3.nautilus
    gnome3.mutter gnome3.gnome-desktop gobjectIntrospection
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
