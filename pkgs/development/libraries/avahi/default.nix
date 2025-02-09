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
      name = "CVE-2021-3502.patch";
      url = "https://github.com/lathiat/avahi/commit/9d31939e55280a733d930b15ac9e4dda4497680c.patch";
      sha256 = "sha256-BXWmrLWUvDxKPoIPRFBpMS3T4gijRw0J+rndp6iDybU=";
    })
    # CVE-2021-3468
    (fetchpatch {
      name = "CVE-2021-3468.patch";
      url = "https://github.com/lathiat/avahi/commit/447affe29991ee99c6b9732fc5f2c1048a611d3b.patch";
      sha256 = "sha256-qWaCU1ZkCg2PmijNto7t8E3pYRN/36/9FrG8okd6Gu8=";
    })
    (fetchpatch {
      name = "CVE-2023-1981.patch";
      url = "https://github.com/lathiat/avahi/commit/a2696da2f2c50ac43b6c4903f72290d5c3fa9f6f.patch";
      sha256 = "sha256-BEYFGCnQngp+OpiKIY/oaKygX7isAnxJpUPCUvg+efc=";
    })
    # CVE-2023-38470
    # https://github.com/lathiat/avahi/pull/457 merged Sep 19
    (fetchpatch {
      name = "CVE-2023-38470.patch";
      url = "https://github.com/lathiat/avahi/commit/94cb6489114636940ac683515417990b55b5d66c.patch";
      sha256 = "sha256-Fanh9bvz+uknr5pAmltqijuUAZIG39JR2Lyq5zGKJ58=";
    })
    # CVE-2023-38473
    # https://github.com/lathiat/avahi/pull/486 merged Oct 18
    (fetchpatch {
      name = "CVE-2023-38473.patch";
      url = "https://github.com/lathiat/avahi/commit/b448c9f771bada14ae8de175695a9729f8646797.patch";
      sha256 = "sha256-/ZVhsBkf70vjDWWG5KXxvGXIpLOZUXdRkn3413iSlnI=";
    })
    # CVE-2023-38472
    # https://github.com/lathiat/avahi/pull/490 merged Oct 19
    (fetchpatch {
      name = "CVE-2023-38472.patch";
      url = "https://github.com/lathiat/avahi/commit/b024ae5749f4aeba03478e6391687c3c9c8dee40.patch";
      sha256 = "sha256-FjR8fmhevgdxR9JQ5iBLFXK0ILp2OZQ8Oo9IKjefCqk=";
    })
    # CVE-2023-38471
    # https://github.com/lathiat/avahi/pull/494 merged Oct 24
    (fetchpatch {
      name = "CVE-2023-38471.patch";
      url = "https://github.com/lathiat/avahi/commit/894f085f402e023a98cbb6f5a3d117bd88d93b09.patch";
      sha256 = "sha256-4dG+5ZHDa+A4/CszYS8uXWlpmA89m7/jhbZ7rheMs7U=";
    })
    # https://github.com/lathiat/avahi/pull/499 merged Oct 25
    # (but with the changes to '.github/workflows/smoke-tests.sh removed)
    ./CVE-2023-38471-2.patch
    # CVE-2023-38469
    # https://github.com/lathiat/avahi/pull/500 merged Oct 25
    # (but with the changes to '.github/workflows/smoke-tests.sh removed)
    ./CVE-2023-38469.patch
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
