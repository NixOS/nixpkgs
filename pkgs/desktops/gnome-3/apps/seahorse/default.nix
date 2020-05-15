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
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "seahorse";
  version = "3.36";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1nqn4a6dr4l1fpzj3mv4swhpnvhjcqlwsyhwm59sdzqgdfx4hbwr";
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

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Seahorse";
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
