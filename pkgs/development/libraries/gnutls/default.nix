{ lib
, stdenv
, fetchurl
, fetchpatch2
, zlib
, lzo
, libtasn1
, nettle
, pkg-config
, lzip
, perl
, gmp
, autoconf
, automake
, libidn2
, libiconv
, texinfo
, unbound
, dns-root-data
, gettext
, util-linux
, cxxBindings ? !stdenv.hostPlatform.isStatic # tries to link libstdc++.so
, tpmSupport ? false
, trousers
, which
, nettools
, libunistring
, withP11-kit ? !stdenv.hostPlatform.isStatic
, p11-kit
, Security  # darwin Security.framework
  # certificate compression - only zlib now, more possible: zstd, brotli

  # for passthru.tests
, curlWithGnuTls
, emacs
, ffmpeg
, haskellPackages
, knot-resolver
, ngtcp2-gnutls
, ocamlPackages
, pkgsStatic
, python3Packages
, qemu
, rsyslog
, openconnect
, samba

, gitUpdater
}:

let

  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # https://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = !stdenv.isFreeBSD && !stdenv.isDarwin
    && stdenv.buildPlatform == stdenv.hostPlatform;

  inherit (stdenv.hostPlatform) isDarwin;
in

stdenv.mkDerivation rec {
  pname = "gnutls";
  version = "3.8.5";

  src = fetchurl {
    url = "mirror://gnupg/gnutls/v${lib.versions.majorMinor version}/gnutls-${version}.tar.xz";
    hash = "sha256-ZiaaLP4OHC2r7Ie9u9irZW85bt2aQN0AaXjgA8+lK/w=";
  };

  outputs = [ "bin" "dev" "out" ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [ "man" "devdoc" ];

  # Not normally useful docs.
  outputInfo = "devdoc";
  outputDoc = "devdoc";

  patches = [
    ./nix-ssl-cert-file.patch
    # Revert https://gitlab.com/gnutls/gnutls/-/merge_requests/1800
    # dlopen isn't as easy in NixPkgs, as noticed in tests broken by this.
    # Without getting the libs into RPATH they won't be found.
    (fetchpatch2 {
      name = "revert-dlopen-compression.patch";
      url = "https://gitlab.com/gnutls/gnutls/-/commit/8584908d6b679cd4e7676de437117a793e18347c.diff";
      revert = true;
      hash = "sha256-r/+Gmwqy0Yc1LHL/PdPLXlErUBC5JxquLzCBAN3LuRM=";
    })
    # Makes the system-wide configuration for RSAES-PKCS1-v1_5 actually apply
    # and makes it enabled by default when the config file is missing
    # Without this an error 113 is thrown when using some RSA certificates
    # see https://gitlab.com/gnutls/gnutls/-/issues/1540
    # "This is pretty sever[e], since it breaks on letsencrypt-issued RSA keys." (comment from above issue)
    (fetchpatch2 {
      name = "fix-rsaes-pkcs1-v1_5-system-wide-configuration.patch";
      url = "https://gitlab.com/gnutls/gnutls/-/commit/2d73d945c4b1dfcf8d2328c4d23187d62ffaab2d.diff";
      hash = "sha256-2aWcLff9jzJnY+XSqCIaK/zdwSLwkNlfDeMlWyRShN8=";
    })
  ];

  # Skip some tests:
  #  - pkg-config: building against the result won't work before installing (3.5.11)
  #  - fastopen: no idea; it broke between 3.6.2 and 3.6.3 (3437fdde6 in particular)
  #  - trust-store: default trust store path (/etc/ssl/...) is missing in sandbox (3.5.11)
  #  - psk-file: no idea; it broke between 3.6.3 and 3.6.4
  # Change p11-kit test to use pkg-config to find p11-kit
  postPatch = ''
    sed '2iexit 77' -i tests/{pkgconfig,fastopen}.sh
    sed '/^void doit(void)/,/^{/ s/{/{ exit(77);/' -i tests/{trust-store,psk-file}.c
    sed 's:/usr/lib64/pkcs11/ /usr/lib/pkcs11/ /usr/lib/x86_64-linux-gnu/pkcs11/:`pkg-config --variable=p11_module_path p11-kit-1`:' -i tests/p11-kit-trust.sh
  '' + lib.optionalString stdenv.hostPlatform.isMusl '' # See https://gitlab.com/gnutls/gnutls/-/issues/945
    sed '2iecho "certtool tests skipped in musl build"\nexit 0' -i tests/cert-tests/certtool.sh
  '';

  preConfigure = "patchShebangs .";
  configureFlags =
    lib.optionals withP11-kit [
      "--with-default-trust-store-file=/etc/ssl/certs/ca-certificates.crt"
      "--with-default-trust-store-pkcs11=pkcs11:"
    ] ++ [
      "--disable-dependency-tracking"
      "--enable-fast-install"
      "--with-unbound-root-key-file=${dns-root-data}/root.key"
      (lib.withFeature withP11-kit "p11-kit")
      (lib.enableFeature cxxBindings "cxx")
    ] ++ lib.optionals (stdenv.hostPlatform.isMinGW) [
      "--disable-doc"
    ];

  enableParallelBuilding = true;

  hardeningDisable = [ "trivialautovarinit" ];

  buildInputs = [ lzo lzip libtasn1 libidn2 zlib gmp libunistring unbound gettext libiconv ]
    ++ lib.optional (withP11-kit) p11-kit
    ++ lib.optional (tpmSupport && stdenv.isLinux) trousers;

  nativeBuildInputs = [ perl pkg-config texinfo ] ++ [ autoconf automake ]
    ++ lib.optionals doCheck [ which nettools util-linux ];

  propagatedBuildInputs = [ nettle ]
    # Builds dynamically linking against gnutls seem to need the framework now.
    ++ lib.optional isDarwin Security;

  inherit doCheck;
  # stdenv's `NIX_SSL_CERT_FILE=/no-cert-file.crt` breaks tests.
  # Also empty files won't work, and we want to avoid potentially impure /etc/
  preCheck = "NIX_SSL_CERT_FILE=${./dummy.crt}";

  # Fixup broken libtool and pkg-config files
  preFixup = lib.optionalString (!isDarwin) ''
    sed ${lib.optionalString tpmSupport "-e 's,-ltspi,-L${trousers}/lib -ltspi,'"} \
        -e 's,-lz,-L${zlib.out}/lib -lz,' \
        -e 's,-L${gmp.dev}/lib,-L${gmp.out}/lib,' \
        -e 's,-lgmp,-L${gmp.out}/lib -lgmp,' \
        -i $out/lib/*.la "$dev/lib/pkgconfig/gnutls.pc"
  '' + ''
    # It seems only useful for static linking but basically noone does that.
    substituteInPlace "$out/lib/libgnutls.la" \
      --replace "-lunistring" ""
  '';


  passthru.updateScript = gitUpdater {
    url = "https://gitlab.com/gnutls/gnutls.git";
  };

  passthru.tests = {
    inherit ngtcp2-gnutls curlWithGnuTls ffmpeg emacs qemu knot-resolver samba openconnect;
    inherit (ocamlPackages) ocamlnet;
    haskell-gnutls = haskellPackages.gnutls;
    python3-gnutls = python3Packages.python3-gnutls;
    rsyslog = rsyslog.override { withGnutls = true; };
    static = pkgsStatic.gnutls;
  };

  meta = with lib; {
    description = "The GNU Transport Layer Security Library";

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
