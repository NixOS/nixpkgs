{ lib, stdenv
, fetchurl
, vala
, meson
, ninja
, libpwquality
, pkg-config
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
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "seahorse";
  version = "40.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-BMIp5q1PHb8TMtWsR68KX/ejzZabA96h6RIE9foG08U=";
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
    libhandy
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

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Seahorse";
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
