{ config, lib, stdenv, fetchurl, zlib, lzo, libtasn1, nettle, pkg-config, lzip
, perl, gmp, autoconf, automake, libidn2, libiconv
, unbound, dns-root-data, gettext, util-linux
, cxxBindings ? !stdenv.hostPlatform.isStatic # tries to link libstdc++.so
, guileBindings ? config.gnutls.guile or false, guile
, tpmSupport ? false, trousers, which, nettools, libunistring
, withP11-kit ? !stdenv.hostPlatform.isStatic, p11-kit
, withSecurity ? true, Security  # darwin Security.framework
# certificate compression - only zlib now, more possible: zstd, brotli
}:

assert guileBindings -> guile != null;
let

  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # https://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = !stdenv.isFreeBSD && !stdenv.isDarwin
      && stdenv.buildPlatform == stdenv.hostPlatform;

  inherit (stdenv.hostPlatform) isDarwin;
in

stdenv.mkDerivation rec {
  pname = "gnutls";
  version = "3.7.6";

  src = fetchurl {
    url = "mirror://gnupg/gnutls/v${lib.versions.majorMinor version}/gnutls-${version}.tar.xz";
    sha256 = "1zv2097v9f6f4c66q7yn3c6gggjk9jz38095ma7v3gs5lccmf1kp";
  };

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];
  # Not normally useful docs.
  outputInfo = "devdoc";
  outputDoc  = "devdoc";

  patches = [ ./nix-ssl-cert-file.patch ]
    # Disable native add_system_trust.
    # FIXME: apparently it's not enough to drop the framework anymore; maybe related to
    # https://gitlab.com/gnutls/gnutls/-/commit/c19cb93d492e45141bfef9b926dfeba36003261c
    ++ lib.optional (isDarwin && !withSecurity) ./no-security-framework.patch;

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
  ] ++ lib.optional guileBindings [
    "--enable-guile"
    "--with-guile-site-dir=\${out}/share/guile/site"
    "--with-guile-site-ccache-dir=\${out}/share/guile/site"
    "--with-guile-extension-dir=\${out}/share/guile/site"
  ];

  enableParallelBuilding = true;

  buildInputs = [ lzo lzip libtasn1 libidn2 zlib gmp libunistring unbound gettext libiconv ]
    ++ lib.optional (withP11-kit) p11-kit
    ++ lib.optional (tpmSupport && stdenv.isLinux) trousers
    ++ lib.optional guileBindings guile;

  nativeBuildInputs = [ perl pkg-config ]
    ++ lib.optionals (isDarwin && !withSecurity) [ autoconf automake ]
    ++ lib.optionals doCheck [ which nettools util-linux ];

  propagatedBuildInputs = [ nettle ]
    # Builds dynamically linking against gnutls seem to need the framework now.
    ++ lib.optional (isDarwin && withSecurity) Security;

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
