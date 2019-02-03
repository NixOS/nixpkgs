{ config, lib, stdenv, zlib, lzo, libtasn1, nettle, pkgconfig, lzip
, perl, gmp, autogen, libidn, p11-kit, libiconv
, guileBindings ? config.gnutls.guile or false, guile
, tpmSupport ? false, trousers, which, nettools, libunistring
, unbound, dns-root-data, gettext

# Version dependent args
, version, src, patches ? [], postPatch ? "", nativeBuildInputs ? []
, buildInputs ? []
, ...}:

assert guileBindings -> guile != null;
let
  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # http://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = !stdenv.isFreeBSD && !stdenv.isDarwin && lib.versionAtLeast version "3.4"
      && stdenv.buildPlatform == stdenv.hostPlatform;
in
stdenv.mkDerivation {
  name = "gnutls-${version}";

  inherit src patches;

  outputs = [ "bin" "dev" "out" "man" "devdoc" ];
  outputInfo = "devdoc";

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
    "--with-unbound-root-key-file=${dns-root-data}/root.key"
  ] ++ lib.optional guileBindings
    [ "--enable-guile" "--with-guile-site-dir=\${out}/share/guile/site" ];

  enableParallelBuilding = true;

  buildInputs = [ lzo lzip libtasn1 libidn p11-kit zlib gmp autogen libunistring unbound gettext libiconv ]
    ++ lib.optional (tpmSupport && stdenv.isLinux) trousers
    ++ lib.optional guileBindings guile
    ++ buildInputs;

  nativeBuildInputs = [ perl pkgconfig ] ++ nativeBuildInputs
    ++ lib.optionals doCheck [ which nettools ];

  propagatedBuildInputs = [ nettle ];

  inherit doCheck;

  # Fixup broken libtool and pkgconfig files
  preFixup = lib.optionalString (!stdenv.isDarwin) ''
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

    homepage = https://www.gnu.org/software/gnutls/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ eelco fpletz ];
    platforms = platforms.all;
  };
}
