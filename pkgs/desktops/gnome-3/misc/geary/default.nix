{ stdenv, fetchurl, fetchpatch, pkgconfig, gtk3, vala, enchant2, wrapGAppsHook, meson, ninja
, desktop-file-utils, gnome-online-accounts, gsettings-desktop-schemas, adwaita-icon-theme
, libnotify, libcanberra-gtk3, libsecret, gmime, isocodes, libxml2, gettext
, sqlite, gcr, json-glib, itstool, libgee, gnome3, webkitgtk, python3
, xvfb_run, dbus, shared-mime-info, libunwind, glib-networking }:

stdenv.mkDerivation rec {
  pname = "geary";
  version = "0.13.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0h9pf2mdskq7mylib1m9hw86nwfmdzyngjl7ywangqipm1k5svjx";
  };

  patches = [
    # gobject-introspection is not needed
    # https://gitlab.gnome.org/GNOME/geary/merge_requests/138
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/geary/commit/d2f1b1076aa942d140e83fdf03b66621c11229f5.patch;
      sha256 = "1dsj4ybnibpi572w9hafm0w90jbjv7wzdl6j8d4c2qg5h7knlvfk";
    })
    # Fixes tests on Aarch64
    # https://gitlab.gnome.org/GNOME/geary/issues/259
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/geary/commit/9c3fdbfb5c792daeb9c3924f798fa83a15096d8a.patch;
      sha256 = "1ihjxnaj0g6gx264kd8cbhs88yp37vwmmcd3lvmz44agf7qcv2ri";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils gettext itstool libxml2 meson ninja
    pkgconfig vala wrapGAppsHook python3
  ];

  buildInputs = [
    adwaita-icon-theme enchant2 gcr gmime gnome-online-accounts
    gsettings-desktop-schemas gtk3 isocodes json-glib libcanberra-gtk3
    libgee libnotify libsecret sqlite webkitgtk glib-networking
    libunwind
  ];

  checkInputs = [ xvfb_run dbus ];

  mesonFlags = [
    "-Dcontractor=true" # install the contractor file (Pantheon specific)
  ];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  doCheck = true;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS=:$XDG_DATA_DIRS:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${shared-mime-info}/share \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test -v --no-stdsplit
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
