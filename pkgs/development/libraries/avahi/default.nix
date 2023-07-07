{ fetchurl
, fetchpatch
, lib
, stdenv
, pkg-config
, libdaemon
, dbus
, perlPackages
, libpcap
, expat
, gettext
, glib
, libiconv
, libevent
, nixosTests
, gtk3Support ? false
, gtk3
, qt5
, qt5Support ? false
, withLibdnssdCompat ? false
, python ? null
, withPython ? false
}:

stdenv.mkDerivation rec {
  pname = "avahi${lib.optionalString withLibdnssdCompat "-compat"}";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/lathiat/avahi/releases/download/v${version}/avahi-${version}.tar.gz";
    sha256 = "1npdixwxxn3s9q1f365x9n9rc5xgfz39hxf23faqvlrklgbhj0q6";
  };

  outputs = [ "out" "dev" "man" ];

  patches = [
    # CVE-2021-36217 / CVE-2021-3502
    (fetchpatch {
      url = "https://github.com/lathiat/avahi/commit/9d31939e55280a733d930b15ac9e4dda4497680c.patch";
      sha256 = "sha256-BXWmrLWUvDxKPoIPRFBpMS3T4gijRw0J+rndp6iDybU=";
    })
    # CVE-2021-3468
    (fetchpatch {
      url = "https://github.com/lathiat/avahi/commit/447affe29991ee99c6b9732fc5f2c1048a611d3b.patch";
      sha256 = "sha256-qWaCU1ZkCg2PmijNto7t8E3pYRN/36/9FrG8okd6Gu8=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    glib
  ];

  buildInputs = [
    libdaemon
    dbus
    glib
    expat
    libiconv
    libevent
  ] ++ (with perlPackages; [
    perl
    XMLParser
  ]) ++ lib.optionals stdenv.isFreeBSD [
    libpcap
  ] ++ lib.optionals gtk3Support [
    gtk3
  ] ++ lib.optionals qt5Support [
    qt5
  ];

  propagatedBuildInputs = lib.optionals withPython (with python.pkgs; [
    python
    pygobject3
    dbus-python
  ]);

  configureFlags = [
    "--disable-gdbm"
    "--disable-mono"
    # Use non-deprecated path https://github.com/lathiat/avahi/pull/376
    "--with-dbus-sys=${placeholder "out"}/share/dbus-1/system.d"
    (lib.enableFeature gtk3Support "gtk3")
    (lib.enableFeature qt5Support "qt5")
    (lib.enableFeature withPython "python")
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--sysconfdir=/etc"
    "--with-distro=${with stdenv.hostPlatform; if isBSD then parsed.kernel.name else "none"}"
    # A systemd unit is provided by the avahi-daemon NixOS module
    "--with-systemdsystemunitdir=no"
  ] ++ lib.optionals withLibdnssdCompat [
    "--enable-compat-libdns_sd"
  ] ++ lib.optionals stdenv.isDarwin [
    # autoipd won't build on darwin
    "--disable-autoipd"
  ];

  installFlags = [
    # Override directories to install into the package.
    # Replace with runstatedir once is merged https://github.com/lathiat/avahi/pull/377
    "avahi_runtime_dir=${placeholder "out"}/run"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  preBuild = lib.optionalString stdenv.isDarwin ''
    sed -i '20 i\
    #define __APPLE_USE_RFC_2292' \
    avahi-core/socket.c
  '';

  postInstall =
    # Maintain compat for mdnsresponder
    lib.optionalString withLibdnssdCompat ''
      ln -s avahi-compat-libdns_sd/dns_sd.h "$dev/include/dns_sd.h"
    '';

  passthru.tests = {
    smoke-test = nixosTests.avahi;
    smoke-test-resolved = nixosTests.avahi-with-resolved;
  };

  meta = with lib; {
    description = "mDNS/DNS-SD implementation";
    homepage = "http://avahi.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lovek323 globin ];

    longDescription = ''
      Avahi is a system which facilitates service discovery on a local
      network.  It is an implementation of the mDNS (for "Multicast
      DNS") and DNS-SD (for "DNS-Based Service Discovery")
      protocols.
    '';
  };
}
