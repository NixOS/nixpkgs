{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, glib
, gettext
, python3
, gnutls
, p11-kit
, libproxy
, gnome3
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "glib-networking";
  version = "2.60.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1mfw44qpmwvz6yzj8c6spx6z357wrmkk15byrkc5byagd82860fm";
  };

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    python3 # for install_script
  ];

  buildInputs = [
    glib
    gnutls
    p11-kit
    libproxy
    gsettings-desktop-schemas
  ];

  doCheck = false; # tests need to access the certificates (among other things)

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Network-related giomodules for glib";
    homepage = https://gitlab.gnome.org/GNOME/glib-networking;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
