{ fetchurl, stdenv, zlib, lzo, libtasn1, nettle, pkgconfig, lzip
, guileBindings, guile, perl, gmp }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {
  name = "gnutls-3.1.22";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.1/${name}.tar.lz";
    sha256 = "177kmq4jn67s7mmb249722nwxmbjwjpphmib7bhzfk43z02j3pvh";
  };

  # FreeBSD doesn't have <alloca.h>, and Gnulib's `alloca' module isn't used.
  patches = stdenv.lib.optional stdenv.isFreeBSD ./guile-gnulib-includes.patch;

  # Note: GMP is a dependency of Nettle, whose public headers include
  # GMP headers, hence the hack.
  configurePhase = ''
    ./configure --prefix="$out"                                 \
      --disable-dependency-tracking --enable-fast-install       \
      --without-p11-kit                                         \
      --with-lzo --with-libtasn1-prefix="${libtasn1}"           \
      --with-libnettle-prefix="${nettle}"                       \
      CPPFLAGS="-I${gmp}/include"                               \
      ${stdenv.lib.optionalString guileBindings
          "--enable-guile --with-guile-site-dir=\"$out/share/guile/site\""}
  '';

  # Build of the Guile bindings is not parallel-safe.  See
  # <http://git.savannah.gnu.org/cgit/gnutls.git/commit/?id=330995a920037b6030ec0282b51dde3f8b493cad>
  # for the actual fix.
  enableParallelBuilding = !guileBindings;

  buildInputs = [ zlib lzo lzip ]
    ++ stdenv.lib.optional guileBindings guile;

  nativeBuildInputs = [ perl pkgconfig ];

  propagatedBuildInputs = [ nettle libtasn1 ];

  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # http://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = (!stdenv.isFreeBSD && !stdenv.isDarwin);

  meta = {
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
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}