{ lib, stdenv
, gettext
, meson
, ninja
, fetchurl
, fetchpatch
, apacheHttpd
, nautilus
, pkg-config
, gtk3
, glib
, libxml2
, systemd
, wrapGAppsHook
, itstool
, libnotify
, mod_dnssd
, gnome
, libcanberra-gtk3
, python3
}:

stdenv.mkDerivation rec {
  pname = "gnome-user-share";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "04r9ck9v4i0d31grbli1d4slw2d6dcsfkpaybkwbzi7wnj72l30x";
  };

  patches = [
    # fix gio-unix-2.0 lookup
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-user-share/commit/8772980d4732c15505b15dccff2ca3c97e96d49d.patch";
      sha256 = "03clzhrx72pq1cbmg2y24hvw4i1xsvrg9ip113fi5bc3w4gcji7p";
    })
    # fix compilation with meson >=0.61
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-user-share/-/commit/c31b0a8f33b95c0077cd5ee2102a71a49bee8abe.patch";
      hash = "sha256-kH+cPBmSErWxsw+IyyjWgENi4I3ZcKjSA9+em8u4DYs=";
    })
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' \
      -e 's,''${HTTP_MODULES_PATH},${apacheHttpd}/modules,' \
      -i data/dav_user_2.4.conf
  '';

  mesonFlags = [
    "-Dhttpd=${apacheHttpd.out}/bin/httpd"
    "-Dmodules_path=${apacheHttpd}/modules"
    "-Dsystemduserunitdir=${placeholder "out"}/etc/systemd/user"
    # In 3.34.0 it defaults to false but it is silently ignored and always installed.
    # Let’s add it anyway in case they decide to make build respect the option in the future.
    "-Dnautilus_extension=true"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    itstool
    libxml2
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    gtk3
    glib
    nautilus
    libnotify
    libcanberra-gtk3
    systemd
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://help.gnome.org/users/gnome-user-share/3.8";
    description = "Service that exports the contents of the Public folder in your home directory on the local network";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
