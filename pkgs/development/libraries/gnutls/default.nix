{
  lib,
  stdenv,
  fetchurl,
  zlib,
  libtasn1,
  nettle,
  pkg-config,
  perl,
  gmp,
  autoconf,
  automake,
  libidn2,
  libiconv,
  texinfo,
  unbound,
  dns-root-data,
  gettext,
  util-linux,
  cxxBindings ? !stdenv.hostPlatform.isStatic, # tries to link libstdc++.so
  tpmSupport ? false,
  trousers,
  which,
  net-tools,
  libunistring,
  withP11-kit ? !stdenv.hostPlatform.isStatic,
  p11-kit,
  # certificate compression - only zlib now, more possible: zstd, brotli

  # for passthru.tests
  curlWithGnuTls,
  emacs,
  ffmpeg,
  haskellPackages,
  knot-resolver,
  ngtcp2-gnutls,
  ocamlPackages,
  pkgsStatic,
  python3Packages,
  qemu,
  rsyslog,
  openconnect,
  samba,

  gitUpdater,
}:

let

  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # https://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck =
    !stdenv.hostPlatform.isFreeBSD
    && !stdenv.hostPlatform.isDarwin
    && stdenv.buildPlatform == stdenv.hostPlatform;

  inherit (stdenv.hostPlatform) isDarwin;
in

stdenv.mkDerivation rec {
  pname = "gnutls";
  version = "3.8.11";

  src = fetchurl {
    url = "mirror://gnupg/gnutls/v${lib.versions.majorMinor version}/gnutls-${version}.tar.xz";
    hash = "sha256-kb0jxKhuvGFS6BMD0gz2zq65e8j4QmbQ+uxuKfF7qiA=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [
    "man"
    "devdoc"
  ];

  # Not normally useful docs.
  outputInfo = "devdoc";
  outputDoc = "devdoc";

  patches = [
    ./nix-ssl-cert-file.patch
  ];

  # Skip some tests:
  #  - pkg-config: building against the result won't work before installing (3.5.11)
  #  - fastopen: no idea; it broke between 3.6.2 and 3.6.3 (3437fdde6 in particular)
  #  - trust-store: default trust store path (/etc/ssl/...) is missing in sandbox (3.5.11)
  #  - psk-file: no idea; it broke between 3.6.3 and 3.6.4
  #  - ktls: requires tls module loaded into kernel and ktls-utils which depends on gnutls
  # Change p11-kit test to use pkg-config to find p11-kit
  postPatch = ''
    sed '2iexit 77' -i tests/{pkgconfig,fastopen}.sh
    sed '/^void doit(void)/,/^{/ s/{/{ exit(77);/' -i tests/{trust-store,psk-file}.c
    sed 's:/usr/lib64/pkcs11/ /usr/lib/pkcs11/ /usr/lib/x86_64-linux-gnu/pkcs11/:`pkg-config --variable=p11_module_path p11-kit-1`:' -i tests/p11-kit-trust.sh
  ''
  + lib.optionalString stdenv.hostPlatform.isMusl ''
    # See https://gitlab.com/gnutls/gnutls/-/issues/945
    sed '2iecho "certtool tests skipped in musl build"\nexit 0' -i tests/cert-tests/certtool.sh
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    sed '2iexit 77' -i tests/{ktls,ktls_keyupdate}.sh
    sed '/-DUSE_KTLS/d' -i tests/Makefile.{am,in}
    sed '/gnutls_ktls/d' -i tests/Makefile.am
    sed '/ENABLE_KTLS_TRUE/d' -i tests/Makefile.in
  ''
  # https://gitlab.com/gnutls/gnutls/-/issues/1721
  + ''
    sed '2iexit 77' -i tests/system-override-compress-cert.sh
  '';

  preConfigure = "patchShebangs .";
  configureFlags =
    lib.optionals withP11-kit [
      "--with-default-trust-store-file=/etc/ssl/certs/ca-certificates.crt"
      "--with-default-trust-store-pkcs11=pkcs11:"
    ]
    ++ [
      "--disable-dependency-tracking"
      "--enable-fast-install"
      "--with-unbound-root-key-file=${dns-root-data}/root.key"
      (lib.withFeature withP11-kit "p11-kit")
      (lib.enableFeature cxxBindings "cxx")
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "--enable-ktls"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isMinGW) [
      "--disable-doc"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && tpmSupport) [
      "--with-trousers-lib=${trousers}/lib/libtspi.so"
    ]
    ++ [
      # do not dlopen in nixpkgs
      "--with-zlib=link"
    ];

  enableParallelBuilding = true;

  hardeningDisable = [ "trivialautovarinit" ];

  buildInputs = [
    libtasn1
    libidn2
    zlib
    gmp
    libunistring
    unbound
    gettext
    libiconv
  ]
  ++ lib.optional withP11-kit p11-kit
  ++ lib.optional (tpmSupport && stdenv.hostPlatform.isLinux) trousers;

  nativeBuildInputs = [
    perl
    pkg-config
    texinfo
  ]
  ++ [
    autoconf
    automake
  ]
  ++ lib.optionals doCheck [
    which
    net-tools
    util-linux
  ];

  propagatedBuildInputs = [ nettle ];

  inherit doCheck;
  # stdenv's `NIX_SSL_CERT_FILE=/no-cert-file.crt` breaks tests.
  # Also empty files won't work, and we want to avoid potentially impure /etc/
  preCheck = "NIX_SSL_CERT_FILE=${./dummy.crt}";

  # Fixup broken libtool and pkg-config files
  preFixup =
    lib.optionalString (!isDarwin) ''
      sed ${lib.optionalString tpmSupport "-e 's,-ltspi,-L${trousers}/lib -ltspi,'"} \
          -e 's,-lz,-L${zlib.out}/lib -lz,' \
          -e 's,-L${gmp.dev}/lib,-L${gmp.out}/lib,' \
          -e 's,-lgmp,-L${gmp.out}/lib -lgmp,' \
          -i $out/lib/*.la "$dev/lib/pkgconfig/gnutls.pc"
    ''
    + ''
      # It seems only useful for static linking but basically noone does that.
      substituteInPlace "$out/lib/libgnutls.la" \
        --replace "-lunistring" ""
    '';

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.com/gnutls/gnutls.git";
  };

  passthru.tests = {
    inherit
      ngtcp2-gnutls
      curlWithGnuTls
      ffmpeg
      emacs
      qemu
      knot-resolver
      samba
      openconnect
      ;
    #inherit (ocamlPackages) ocamlnet;
    #haskell-gnutls = haskellPackages.gnutls;
    python3-gnutls = python3Packages.python3-gnutls;
    rsyslog = rsyslog.override { withGnutls = true; };
    static = pkgsStatic.gnutls;
  };

  meta = with lib; {
    description = "GNU Transport Layer Security Library";

    longDescription = ''
      GnuTLS is a project that aims to develop a library which
      provides a secure layer, over a reliable transport
      layer. Currently the GnuTLS library implements the proposed standards by
      the IETF's TLS working group.

      Quoting from the TLS protocol specification:

      "The TLS protocol provides communications privacy over the
      Internet. The protocol allows client/server applications to
      communicate in a way that is designed to prevent eavesdropping,
      tampering, or message forgery."
    '';

    homepage = "https://gnutls.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ vcunat ];
    platforms = platforms.all;
  };
}
