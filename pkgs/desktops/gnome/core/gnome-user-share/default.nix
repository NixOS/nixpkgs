{ stdenv
, lib
, gettext
, meson
, ninja
, fetchurl
, apacheHttpd
, pkg-config
, glib
, libxml2
, systemd
, wrapGAppsHook
, itstool
, mod_dnssd
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-user-share";
  version = "43.alpha";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-share/${lib.versions.major version}/gnome-user-share-${version}.tar.xz";
    sha256 = "7XmBH77PI6o0rIUx9j7y4nSw73/CjyXo7Iz3Oy9DPpo=";
  };

  preConfigure = ''
    sed -e 's,^LoadModule dnssd_module.\+,LoadModule dnssd_module ${mod_dnssd}/modules/mod_dnssd.so,' \
      -e 's,''${HTTP_MODULES_PATH},${apacheHttpd}/modules,' \
      -i data/dav_user_2.4.conf
  '';

  mesonFlags = [
    "-Dhttpd=${apacheHttpd.out}/bin/httpd"
    "-Dmodules_path=${apacheHttpd}/modules"
    "-Dsystemduserunitdir=${placeholder "out"}/etc/systemd/user"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    itstool
    libxml2
    wrapGAppsHook
  ];

  buildInputs = [
    glib
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
