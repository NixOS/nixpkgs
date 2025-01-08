{
  stdenv,
  fetchurl,
  lib,
  file,
  pkg-config,
  autoconf,
  glib,
  dbus-glib,
  json-glib,
  gtk2,
  libindicator-gtk2,
  libdbusmenu-gtk2,
  libappindicator-gtk2,
}:

stdenv.mkDerivation rec {
  pname = "indicator-application-gtk2";
  version = "12.10.0.1";

  src = fetchurl {
    url = "${meta.homepage}/indicator-application-gtk2/i-a-${version}/+download/indicator-application-${version}.tar.gz";
    sha256 = "1xqsb6c1pwawabw854f7aybjrgyhc2r1316i9lyjspci51zk5m7v";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    dbus-glib # dbus-binding-tool
  ];

  buildInputs = [
    glib
    dbus-glib
    json-glib
    gtk2
    libindicator-gtk2
    libdbusmenu-gtk2
    libappindicator-gtk2
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

  meta = with lib; {
    description = "Indicator to take menus from applications and place them in the panel (GTK 2 library for Xfce/LXDE)";
    homepage = "https://launchpad.net/indicators-gtk2";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
