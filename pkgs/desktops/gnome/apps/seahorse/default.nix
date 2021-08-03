{ lib, stdenv
, fetchurl
, vala
, meson
, ninja
, libpwquality
, pkg-config
, gtk3
, glib
, glib-networking
, wrapGAppsHook
, itstool
, gnupg
, libsoup
, gnome
, gpgme
, python3
, openldap
, gcr
, libsecret
, avahi
, p11-kit
, openssh
, gsettings-desktop-schemas
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "seahorse";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-fscFezhousbqBB/aghQKOfXsnlsYi0UJFNRTvC1V0Cw=";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    itstool
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    glib
    glib-networking
    gcr
    gsettings-desktop-schemas
    gnupg
    gnome.adwaita-icon-theme
    gpgme
    libsecret
    avahi
    libsoup
    p11-kit
    openssh
    openldap
    libpwquality
    libhandy
  ];

  postPatch = ''
    patchShebangs build-aux/
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Seahorse";
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
