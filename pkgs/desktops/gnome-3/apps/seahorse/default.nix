{ stdenv
, fetchurl
, fetchpatch
, vala
, meson
, ninja
, libpwquality
, pkgconfig
, gtk3
, glib
, wrapGAppsHook
, itstool
, gnupg
, libsoup
, gnome3
, gpgme
, python3
, openldap
, gcr
, libsecret
, avahi
, p11-kit
, openssh
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "seahorse";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19c2zylwgycb5q9hal8rmflc2sywc5c2grpsfsq3rf37i9lfwynw";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
    itstool
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    glib
    gcr
    gsettings-desktop-schemas
    gnupg
    gnome3.adwaita-icon-theme
    gpgme
    libsecret
    avahi
    libsoup
    p11-kit
    openssh
    openldap
    libpwquality
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
