{ fetchurl, stdenv, zlib, lzo, libtasn1, nettle, pkgconfig, lzip
, guileBindings, guile, perl, gmp }:

assert guileBindings -> guile != null;

stdenv.mkDerivation (rec {

  name = "gnutls-3.2.10";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/${name}.tar.lz";
    sha256 = "1g1w93d66sz51977zbqd56641r501a1djcwhykbjm8alhyz1564h";
  };

  # Note: GMP is a dependency of Nettle, whose public headers include
  # GMP headers, hence the hack.
  configurePhase = ''
    ./configure --prefix="$out"                                 \
      --disable-dependency-tracking --enable-fast-install       \
      --without-p11-kit                                         \
      --with-lzo --with-libtasn1-prefix="${libtasn1}"           \
      --with-libnettle-prefix="${nettle}"                       \
      CPPFLAGS="-I${gmp}/include"                               \
      ${if guileBindings
        then "--enable-guile --with-guile-site-dir=\"$out/share/guile/site\""
        else ""}
  '';

  # Build of the Guile bindings is not parallel-safe.  See
  # <http://git.savannah.gnu.org/cgit/gnutls.git/commit/?id=330995a920037b6030ec0282b51dde3f8b493cad>
  # for the actual fix.
  enableParallelBuilding = false;

  buildInputs = [ zlib lzo lzip ]
    ++ stdenv.lib.optional guileBindings guile;

  nativeBuildInputs = [ perl pkgconfig ];

  propagatedBuildInputs = [ nettle libtasn1 ];

  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # http://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = (!stdenv.isFreeBSD && !stdenv.isDarwin);

  meta = with stdenv.lib; {
    description = "The GNU Transport Layer Security Library";

    longDescription = ''
       GnuTLS is a project that aims to develop a library which
       provides a secure layer, over a reliable transport
       layer. Currently the GnuTLS library implements the proposed
       standards by the IETF's TLS working group.

       Quoting from the TLS protocol specification:

       "The TLS protocol provides communications privacy over the
       Internet. The protocol allows client/server applications to
       communicate in a way that is designed to prevent eavesdropping,
       tampering, or message forgery."
    '';

    homepage = http://www.gnu.org/software/gnutls/;
    license = "LGPLv2.1+";
    maintainers = [ ];
    platforms = platforms.all;
  };
}

//

(stdenv.lib.optionalAttrs stdenv.isFreeBSD {
  # FreeBSD doesn't have <alloca.h>, and Gnulib's `alloca' module isn't used.
  patches = [ ./guile-gnulib-includes.patch ];
})

//

(stdenv.lib.optionalAttrs stdenv.isDarwin {
  # multiple definitions of '_gnutls_x86_cpuid_s' cause linker to fail.
  # the patch is: https://www.gitorious.org/gnutls/gnutls/commit/54768ca1cd9049bbd1c695696ef3c8595c6052db
  # discussion: http://osdir.com/ml/gnutls-devel-gnu/2014-02/msg00012.html
  patches = [ ./fix_gnutls_x86_cpuid_s_multi_definitions.patch ];
})

)
