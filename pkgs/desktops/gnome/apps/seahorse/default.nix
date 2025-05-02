{ stdenv
, lib
, fetchpatch
, fetchurl
, vala
, meson
, ninja
, libpwquality
, pkg-config
, gtk3
, glib
, glib-networking
, wrapGAppsHook3
, itstool
, gnupg
, desktop-file-utils
, libsoup_3
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
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-Wx0b+6dPNlgifzyC4pbzMN0PzR70Y2tqIYIo/uXqgy0=";
  };

  patches = [
    (fetchpatch {
      name = "gpg-2.4.patch";
      url = "https://gitlab.gnome.org/GNOME/seahorse/-/commit/9260c74779be3d7a378db0671af862ffa3573d42.patch";
      hash = "sha256-4QiFgH4jC1ucmA9fFozUQZ3Mat76SgpYkMpRz80RH64=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    itstool
    wrapGAppsHook3
    python3
    openssh
    gnupg
    desktop-file-utils
    gcr
  ];

  buildInputs = [
    gtk3
    glib
    glib-networking
    gcr
    gsettings-desktop-schemas
    gpgme
    libsecret
    avahi
    libsoup_3
    p11-kit
    openldap
    libpwquality
    libhandy
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs build-aux/gpg_check_version.py
  '';

  preCheck = ''
    # Add “org.gnome.crypto.pgp” GSettings schema to path
    # to make it available for “gpgme-backend” test.
    # It is used by Seahorse’s internal “common” library.
    addToSearchPath XDG_DATA_DIRS "${glib.getSchemaDataDirPath gcr}"
    # The same test also requires home directory so that it can store settings.
    export HOME=$TMPDIR
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Pick up icons from Gcr
      --prefix XDG_DATA_DIRS : "${gcr}/share"
    )
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/seahorse";
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    mainProgram = "seahorse";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
