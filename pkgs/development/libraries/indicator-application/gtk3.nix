{ stdenv, fetchurl, lib, file
, pkgconfig, autoconf
, glib, dbus-glib, json-glib
, gtk3, libindicator-gtk3, libdbusmenu-gtk3, libappindicator-gtk3 }:

with lib;

stdenv.mkDerivation rec {
  name = "indicator-application-gtk3-${version}";
  version = "${versionMajor}.${versionMinor}";
  versionMajor = "12.10";
  versionMinor = "0";

  src = fetchurl {
    url = "${meta.homepage}/${versionMajor}/${version}/+download/indicator-application-${version}.tar.gz";
    sha256 = "1z8ar0k47l4his7zvffbc2kn658nid51svqnfv0dms601w53gbpr";
  };

  nativeBuildInputs = [ pkgconfig autoconf ];

  buildInputs = [
    glib dbus-glib json-glib
    gtk3 libindicator-gtk3 libdbusmenu-gtk3 libappindicator-gtk3
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'DBUSSERVICEDIR=`$PKG_CONFIG --variable=session_bus_services_dir dbus-1`' \
                "DBUSSERVICEDIR=$out/share/dbus-1/services"
    autoconf
    for f in {configure,ltmain.sh,m4/libtool.m4}; do
      substituteInPlace $f \
        --replace /usr/bin/file ${file}/bin/file
    done
    substituteInPlace src/Makefile.in \
      --replace 'applicationlibdir = $(INDICATORDIR)' "applicationlibdir = $out/lib"
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "Indicator to take menus from applications and place them in the panel";
    homepage = https://launchpad.net/indicator-application;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
