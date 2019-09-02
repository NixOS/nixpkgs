{ fetchurl, fetchpatch, stdenv, pkgconfig, libdaemon, dbus, perlPackages
, expat, gettext, intltool, glib, libiconv
, gtk3Support ? false, gtk3 ? null
, qt4 ? null
, qt4Support ? false
, withLibdnssdCompat ? false
, python ? null
, withPython ? false }:

assert qt4Support -> qt4 != null;

stdenv.mkDerivation rec {
  name = "avahi${stdenv.lib.optionalString withLibdnssdCompat "-compat"}-${version}";
  version = "0.7";

  src = fetchurl {
    url = "https://github.com/lathiat/avahi/releases/download/v${version}/avahi-${version}.tar.gz";
    sha256 = "0128n7jlshw4bpx0vg8lwj8qwdisjxi7mvniwfafgnkzzrfrpaap";
  };

  patches = [
    ./no-mkdir-localstatedir.patch
    (fetchpatch {
      name ="CVE-2017-6519-CVE-2018-100084.patch";
      url = https://github.com/lathiat/avahi/commit/e111def44a7df4624a4aa3f85fe98054bffb6b4f.patch;
      sha256 = "06n7b7kz6xcc35c7xjfc1kj3k2llyjgi09nhy0ci32l1bhacjw0q";
    })
  ];

  buildInputs = [ libdaemon dbus glib expat libiconv ]
    ++ (with perlPackages; [ perl XMLParser ])
    ++ (stdenv.lib.optional gtk3Support gtk3)
    ++ (stdenv.lib.optional qt4Support qt4);

  propagatedBuildInputs =
    stdenv.lib.optionals withPython (with python.pkgs; [ python pygobject3 dbus-python ]);

  nativeBuildInputs = [ pkgconfig gettext intltool glib ];

  configureFlags =
    [ "--disable-qt3" "--disable-gdbm" "--disable-mono"
      "--disable-gtk"
      (stdenv.lib.enableFeature gtk3Support "gtk3")
      "--${if qt4Support then "enable" else "disable"}-qt4"
      (stdenv.lib.enableFeature withPython "python")
      "--localstatedir=/var" "--with-distro=none"
      # A systemd unit is provided by the avahi-daemon NixOS module
      "--with-systemdsystemunitdir=no" ]
    ++ stdenv.lib.optional withLibdnssdCompat "--enable-compat-libdns_sd"
    # autoipd won't build on darwin
    ++ stdenv.lib.optional stdenv.isDarwin "--disable-autoipd";

  NIX_CFLAGS_COMPILE = "-DAVAHI_SERVICE_DIR=\"/etc/avahi/services\"";

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i '20 i\
    #define __APPLE_USE_RFC_2292' \
    avahi-core/socket.c
  '';

  postInstall =
    # Maintain compat for mdnsresponder and howl
    stdenv.lib.optionalString withLibdnssdCompat ''
      ln -s avahi-compat-libdns_sd/dns_sd.h "$out/include/dns_sd.h"
    '';
  /*  # these don't exist (anymore?)
    ln -s avahi-compat-howl $out/include/howl
    ln -s avahi-compat-howl.pc $out/lib/pkgconfig/howl.pc
  */

  meta = with stdenv.lib; {
    description = "mDNS/DNS-SD implementation";
    homepage    = http://avahi.org;
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
