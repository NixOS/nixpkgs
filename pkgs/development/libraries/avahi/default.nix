{ fetchurl, fetchpatch, lib, stdenv, pkg-config, libdaemon, dbus, perlPackages
, expat, gettext, intltool, glib, libiconv, writeShellScriptBin, libevent
, gtk3Support ? false, gtk3 ? null
, qt4 ? null
, qt4Support ? false
, qt5 ? null
, qt5Support ? false
, withLibdnssdCompat ? false
, python ? null
, withPython ? false }:

assert qt4Support -> qt4 != null;

let
  # despite the configure script claiming it supports $PKG_CONFIG, it doesnt respect it
  pkg-config-helper = writeShellScriptBin "pkg-config" ''exec $PKG_CONFIG "$@"'';
in

stdenv.mkDerivation rec {
  name = "avahi${lib.optionalString withLibdnssdCompat "-compat"}-${version}";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/lathiat/avahi/releases/download/v${version}/avahi-${version}.tar.gz";
    sha256 = "1npdixwxxn3s9q1f365x9n9rc5xgfz39hxf23faqvlrklgbhj0q6";
  };

  prePatch = ''
    substituteInPlace configure \
      --replace pkg-config "$PKG_CONFIG"
  '';

  patches = [
    ./no-mkdir-localstatedir.patch
  ];

  buildInputs = [ libdaemon dbus glib expat libiconv libevent ]
    ++ (with perlPackages; [ perl XMLParser ])
    ++ (lib.optional gtk3Support gtk3)
    ++ (lib.optional qt4Support qt4)
    ++ (lib.optional qt5Support qt5);

  propagatedBuildInputs =
    lib.optionals withPython (with python.pkgs; [ python pygobject3 dbus-python ]);

  nativeBuildInputs = [ pkg-config pkg-config-helper gettext intltool glib ];

  configureFlags =
    [ "--disable-qt3" "--disable-gdbm" "--disable-mono"
      "--disable-gtk" "--with-dbus-sys=${placeholder "out"}/share/dbus-1/system.d"
      (lib.enableFeature gtk3Support "gtk3")
      "--${if qt4Support then "enable" else "disable"}-qt4"
      "--${if qt5Support then "enable" else "disable"}-qt5"
      (lib.enableFeature withPython "python")
      "--localstatedir=/var" "--with-distro=none"
      # A systemd unit is provided by the avahi-daemon NixOS module
      "--with-systemdsystemunitdir=no" ]
    ++ lib.optional withLibdnssdCompat "--enable-compat-libdns_sd"
    # autoipd won't build on darwin
    ++ lib.optional stdenv.isDarwin "--disable-autoipd";

  NIX_CFLAGS_COMPILE = "-DAVAHI_SERVICE_DIR=\"/etc/avahi/services\"";

  preBuild = lib.optionalString stdenv.isDarwin ''
    sed -i '20 i\
    #define __APPLE_USE_RFC_2292' \
    avahi-core/socket.c
  '';

  postInstall =
    # Maintain compat for mdnsresponder and howl
    lib.optionalString withLibdnssdCompat ''
      ln -s avahi-compat-libdns_sd/dns_sd.h "$out/include/dns_sd.h"
    '';
  /*  # these don't exist (anymore?)
    ln -s avahi-compat-howl $out/include/howl
    ln -s avahi-compat-howl.pc $out/lib/pkgconfig/howl.pc
  */

  meta = with lib; {
    description = "mDNS/DNS-SD implementation";
    homepage    = "http://avahi.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ lovek323 globin ];

    longDescription = ''
      Avahi is a system which facilitates service discovery on a local
      network.  It is an implementation of the mDNS (for "Multicast
      DNS") and DNS-SD (for "DNS-Based Service Discovery")
      protocols.
    '';
  };
}
