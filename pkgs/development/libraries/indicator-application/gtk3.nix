{ stdenv, fetchbzr
, pkgconfig, systemd, autoreconfHook
, glib, dbus-glib, json-glib
, gtk3, libindicator-gtk3, libdbusmenu-gtk3, libappindicator-gtk3 }:

stdenv.mkDerivation rec {
  pname = "indicator-application";
  version = "12.10.1";

  name = "${pname}-gtk3-${version}";

  src = fetchbzr {
    url = "https://code.launchpad.net/~indicator-applet-developers/${pname}/trunk.17.04";
    rev = "260";
    sha256 = "1f0jdyqqb5g86zdpbcyn16x94yjigsfiv2kf73dvni5rp1vafbq1";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [
    glib dbus-glib json-glib systemd
    gtk3 libindicator-gtk3 libdbusmenu-gtk3 libappindicator-gtk3
  ];

  postPatch = ''
    substituteInPlace data/Makefile.am \
      --replace "/etc/xdg/autostart" "$out/etc/xdg/autostart"
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

  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "$(out)/lib/systemd/user";
  PKG_CONFIG_INDICATOR3_0_4_INDICATORDIR = "$(out)/lib/indicators3/7/";

  # Upstart is not used in NixOS
  postFixup = ''
    rm -rf $out/share/indicator-application/upstart
    rm -rf $out/share/upstart
  '';

  meta = with stdenv.lib; {
    description = "Indicator to take menus from applications and place them in the panel";
    homepage = https://launchpad.net/indicator-application;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
