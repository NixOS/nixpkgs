{ stdenv, fetchurl, pkgconfig, gtk3, vala, enchant2, wrapGAppsHook, meson, ninja
, desktop-file-utils, gnome-online-accounts, gsettings-desktop-schemas, adwaita-icon-theme
, libcanberra-gtk3, libsecret, gmime, isocodes, libxml2, gettext
, sqlite, gcr, json-glib, itstool, libgee, gnome3, webkitgtk, python3
, xvfb_run, dbus, shared-mime-info, libunwind, libunity, folks, glib-networking
, gobject-introspection, gspell, appstream-glib, libytnef, libhandy }:

stdenv.mkDerivation rec {
  pname = "geary";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1bx57g8199pcqh1p90dlnca2g1kpyrifr6g8m1rdjmpm2a1r993v";
  };

  nativeBuildInputs = [
    desktop-file-utils gettext itstool libxml2 meson ninja
    pkgconfig vala wrapGAppsHook python3 appstream-glib
    gobject-introspection
  ];

  buildInputs = [
    adwaita-icon-theme enchant2 gcr gmime gnome-online-accounts
    gsettings-desktop-schemas gtk3 isocodes json-glib libcanberra-gtk3
    libgee libsecret sqlite webkitgtk glib-networking
    libunwind libunity folks gspell libytnef libhandy
  ];

  checkInputs = [ xvfb_run dbus ];

  mesonFlags = [
    "-Dcontractor=true" # install the contractor file (Pantheon specific)
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py build-aux/git_version.py
    patchShebangs build-aux/post_install.py build-aux/git_version.py

    chmod +x desktop/geary-attach
  '';

  doCheck = true;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS=:$XDG_DATA_DIRS:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${shared-mime-info}/share \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test -v --no-stdsplit
  '';

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Geary;
    description = "Mail client for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
