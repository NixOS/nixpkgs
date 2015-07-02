{ fetchurl, stdenv, autoreconfHook, zlib, lzo, libtasn1, nettle, pkgconfig, lzip
, guileBindings, guile, perl, gmp, libidn, p11_kit, unbound, trousers

# Version dependent args
, version, src, patches ? []
, ...}:

assert guileBindings -> guile != null;

let
  inherit (stdenv.lib) optional optionals optionalString;
in
stdenv.mkDerivation rec {
  name = "gnutls-${version}";

  inherit src patches;

  configureFlags =
    # FIXME: perhaps use $SSL_CERT_FILE instead
    optional stdenv.isLinux "--with-default-trust-store-file=/etc/ssl/certs/ca-certificates.crt"
  ++ [
    "--disable-dependency-tracking"
    "--enable-fast-install"
  ] ++ optionals guileBindings
    [ "--enable-guile" "--with-guile-site-dir=\${out}/share/guile/site" ];

  # Build of the Guile bindings is not parallel-safe.  See
  # <http://git.savannah.gnu.org/cgit/gnutls.git/commit/?id=330995a920037b6030ec0282b51dde3f8b493cad>
  # for the actual fix.
  enableParallelBuilding = !guileBindings;

  buildInputs = [ lzo lzip nettle libtasn1 libidn p11_kit zlib gmp ]
    ++ optional stdenv.isLinux trousers
    ++ [ unbound ]
    ++ optional guileBindings guile;

  nativeBuildInputs = [ perl pkgconfig autoreconfHook ];

  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # http://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = (!stdenv.isFreeBSD && !stdenv.isDarwin);

  # Fixup broken libtool and pkgconfig files
  preFixup = optionalString (!stdenv.isDarwin) ''
    sed -e 's,-ltspi,-L${trousers}/lib -ltspi,' \
        -e 's,-lz,-L${zlib}/lib -lz,' \
        -e 's,-lgmp,-L${gmp}/lib -lgmp,' \
        -i $out/lib/libgnutls.la $out/lib/pkgconfig/gnutls.pc
  '';

  meta = with stdenv.lib; {
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

    homepage = http://www.gnu.org/software/gnutls/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ eelco wkennington ];
    platforms = platforms.all;
  };
}
