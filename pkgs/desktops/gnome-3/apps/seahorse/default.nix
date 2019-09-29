{ stdenv, fetchurl, fetchpatch, vala, meson, ninja, libpwquality
, pkgconfig, gtk3, glib, gobject-introspection
, wrapGAppsHook, itstool, gnupg, libsoup
, gnome3, gpgme, python3, openldap, gcr
, libsecret, avahi, p11-kit, openssh, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "seahorse";
  version = "3.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0d8zdzmlz7fjv9xl20zl4ckidf465mvdjnbpxy3k08y9iw423q4x";
  };

  patches = [
    # fix build with recent libsecret
    # https://gitlab.gnome.org/GNOME/seahorse/merge_requests/83
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/seahorse/commit/d9db29db567012b7c72e85e1be1fbf55fcc9b667.patch;
      sha256 = "004zgs0n0hfc4yfmiy9lj37d67m7wxdf42sf7bzn2c3hcvpl0rcj";
    })
  ];

  doCheck = true;

  nativeBuildInputs = [
    meson ninja pkgconfig vala itstool wrapGAppsHook
    python3 gobject-introspection
  ];
  buildInputs = [
    gtk3 glib gcr
    gsettings-desktop-schemas gnupg
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
