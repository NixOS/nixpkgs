{ stdenv, fetchurl, meson, ninja, wrapGAppsHook, pkgconfig, gettext, itstool, libvirt-glib
, glib, gobject-introspection, libxml2, gtk3, gtk-vnc, freerdp, libvirt, spice-gtk, python3
, spice-protocol, libsoup, libosinfo, systemd, tracker, tracker-miners, vala
, libcap, yajl, gmp, gdbm, cyrus_sasl, gnome3, librsvg, desktop-file-utils
, mtools, cdrkit, libcdio, libusb, libarchive, acl, libgudev, libsecret
, libcap_ng, numactl, xen, libapparmor, json-glib, webkitgtk, vte
}:

let
  version = "3.34.0";
in stdenv.mkDerivation rec {
  pname = "gnome-boxes";
  inherit version;

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-boxes/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "07qjrb1qgfznvm0l2jm99d212dvw3iaw76czq5q1msnghpdw67qd";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson ninja vala pkgconfig gettext itstool wrapGAppsHook gobject-introspection desktop-file-utils python3
  ];

  # Required for USB redirection PolicyKit rules file
  propagatedUserEnvPkgs = [ spice-gtk ];

  buildInputs = [
    libvirt-glib glib gtk3 gtk-vnc freerdp libxml2
    libvirt spice-gtk spice-protocol libsoup json-glib webkitgtk libosinfo systemd
    tracker tracker-miners libcap yajl gmp gdbm cyrus_sasl libusb libarchive
    gnome3.adwaita-icon-theme librsvg acl libgudev libsecret
    libcap_ng numactl xen libapparmor vte
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${stdenv.lib.makeBinPath [ mtools cdrkit libcdio ]}")
  '';

  postPatch = ''
    chmod +x build-aux/post_install.py # patchShebangs requires executable file
    patchShebangs build-aux/post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-boxes";
      attrPath = "gnome3.gnome-boxes";
    };
  };

  meta = with stdenv.lib; {
    description = "Simple GNOME 3 application to access remote or virtual systems";
    homepage = https://wiki.gnome.org/Apps/Boxes;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
