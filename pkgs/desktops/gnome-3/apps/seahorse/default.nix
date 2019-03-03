{ stdenv, fetchurl, vala, meson, ninja, libpwquality
, pkgconfig, gtk3, glib, gobject-introspection
, wrapGAppsHook, itstool, gnupg, libsoup
, gnome3, gpgme, python3, openldap, gcr
, libsecret, avahi, p11-kit, openssh }:

stdenv.mkDerivation rec {
  pname = "seahorse";
  version = "3.31.91";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1595h8ycklgwgz2d2pc60q7xad3hfxsaxsc03s2cdf0sad1a3314";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson ninja pkgconfig vala itstool wrapGAppsHook
    python3 gobject-introspection
  ];
  buildInputs = [
    gtk3 glib gcr
    gnome3.gsettings-desktop-schemas gnupg
    gnome3.adwaita-icon-theme gpgme
    libsecret avahi libsoup p11-kit
    openssh openldap libpwquality
  ];

  postPatch = ''
    patchShebangs build-aux/
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Seahorse;
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
