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
  version = "41.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-5u7AnoEESClfVH8YwdV3K2XD7cHZ5aJZXxC13eaJKfU=";
  };

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

  doCheck = true;

  postPatch = ''
    patchShebangs build-aux/
  '';

  preCheck = ''
    # Add “org.gnome.crypto.pgp” GSettings schema to path
    # to make it available for “gpgme-backend” test.
    # It is used by Seahorse’s internal “common” library.
    addToSearchPath XDG_DATA_DIRS "${glib.getSchemaPath gcr}/../.."
    # The same test also requires home directory so that it can store settings.
    export HOME=$TMPDIR
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
