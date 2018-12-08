{ stdenv, fetchurl, vala, meson, ninja
, pkgconfig, gtk3, glib, gobject-introspection
, wrapGAppsHook, itstool, gnupg, libsoup
, gnome3, gpgme, python3, openldap
, libsecret, avahi, p11-kit, openssh }:

let
  pname = "seahorse";
  version = "3.30";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1sbj1czlx1fakm72dwgbn0bwm12j838yaky4mkf6hf8j8afnxmzp";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson ninja pkgconfig vala itstool wrapGAppsHook
    python3 gobject-introspection
  ];
  buildInputs = [
    gtk3 glib gnome3.gcr
    gnome3.gsettings-desktop-schemas gnupg
    gnome3.defaultIconTheme gpgme
    libsecret avahi libsoup p11-kit
    openssh openldap
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
