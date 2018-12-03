{ lib, stdenv, zlib, lzo, libtasn1, nettle, pkgconfig, lzip
, guileBindings, guile, perl, gmp, autogen, libidn, p11-kit, unbound, libiconv
, tpmSupport ? true, trousers, nettools, gperftools, gperf, gettext, automake
, yacc, texinfo

# Version dependent args
, version, src, patches ? [], postPatch ? "", nativeBuildInputs ? []
, ...}:

assert guileBindings -> guile != null;
let
  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # http://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = !stdenv.isFreeBSD && !stdenv.isDarwin && lib.versionAtLeast version "3.4";
in
stdenv.mkDerivation {
  name = "gnutls-kdh-${version}";

  inherit src patches;

  outputs = [ "bin" "dev" "out" ];

  patchPhase = ''
      # rm -fR ./po
      # substituteInPlace configure "po/Makefile.in" " "
      substituteInPlace doc/manpages/Makefile.in  --replace "gnutls_cipher_list.3" " "
      substituteInPlace doc/manpages/Makefile.in  --replace "gnutls_cipher_self_test.3" " "
      substituteInPlace doc/manpages/Makefile.in  --replace "gnutls_digest_self_test.3" " "
      substituteInPlace doc/manpages/Makefile.in  --replace "gnutls_mac_self_test.3" " "
      substituteInPlace doc/manpages/Makefile.in  --replace "gnutls_pk_self_test.3" " "
      printf "all: ;\n\ninstall: ;" > "po/Makefile.in"
      printf "all: ;\n\ninstall: ;" > "po/Makefile.in.in"
      '';

  postPatch = lib.optionalString (lib.versionAtLeast version "3.4") ''
    sed '2iecho "name constraints tests skipped due to datefudge problems"\nexit 0' \
      -i tests/cert-tests/name-constraints
  '' + postPatch;

  preConfigure = "patchShebangs .";
  configureFlags =
    lib.optional stdenv.isLinux "--with-default-trust-store-file=/etc/ssl/certs/ca-certificates.crt"
  ++ [
    "--disable-dependency-tracking"
    "--enable-fast-install"
  ] ++ lib.optional guileBindings
    [ "--enable-guile" "--with-guile-site-dir=\${out}/share/guile/site" ];

  # Build of the Guile bindings is not parallel-safe.  See
  # <https://github.com/arpa2/gnutls-kdh/commit/330995a920037b6030ec0282b51dde3f8b493cad>
  # for the actual fix.  Also an apparent race in the generation of
  # systemkey-args.h.
  enableParallelBuilding = false;

  buildInputs = [ lzo lzip nettle libtasn1 libidn p11-kit zlib gmp
  autogen gperftools gperf gettext automake yacc texinfo ]
    ++ lib.optional doCheck nettools
    ++ lib.optional (stdenv.isFreeBSD || stdenv.isDarwin) libiconv
    ++ lib.optional (tpmSupport && stdenv.isLinux) trousers
    ++ [ unbound ]
    ++ lib.optional guileBindings guile;

  nativeBuildInputs = [ perl pkgconfig ] ++ nativeBuildInputs;

  #inherit doCheck;
  doCheck = false;

  # Fixup broken libtool and pkgconfig files
  preFixup = lib.optionalString (!stdenv.isDarwin) ''
    sed ${lib.optionalString tpmSupport "-e 's,-ltspi,-L${trousers}/lib -ltspi,'"} \
        -e 's,-lz,-L${zlib.out}/lib -lz,' \
        -e 's,-L${gmp.dev}/lib,-L${gmp.out}/lib,' \
        -e 's,-lgmp,-L${gmp.out}/lib -lgmp,' \
        -i $out/lib/*.la "$dev/lib/pkgconfig/gnutls.pc"
  '';

  meta = with lib; {
    description = "GnuTLS with additional TLS-KDH ciphers: Kerberos + Diffie-Hellman";

    longDescription = ''
       The ARPA2 project aims to add security. This is an enhanced
       version of GnuTLS,  a project that aims to develop a library which
       provides a secure layer, over a reliable transport
       layer. It adds TLS-KDH ciphers: Kerberos + Diffie-Hellman.
    '';

    homepage = https://github.com/arpa2/gnutls-kdh;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };
}
