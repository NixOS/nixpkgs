{ fetchurl, stdenv, zlib, lzo, libtasn1, nettle
, guileBindings, guile, perl, gmp }:

assert guileBindings -> guile != null;

stdenv.mkDerivation (rec {

  name = "gnutls-3.0.22";

  src = fetchurl {
    url = "mirror://gnu/gnutls/${name}.tar.xz";
    sha256 = "1pp90fm27qi5cd0pq18xcmnl79xcbfwxc54bg1xi1wv0vryqdpcr";
  };

  # FIXME: Turn into a Nix list.
  configurePhase = ''
    ./configure --prefix="$out"                                 \
      --disable-dependency-tracking --enable-fast-install       \
      --without-p11-kit                                         \
      --with-lzo --with-libtasn1-prefix="${libtasn1}"		\
      ${if guileBindings
        then "--enable-guile --with-guile-site-dir=\"$out/share/guile/site\""
        else ""}${if stdenv.isSunOS
          # TODO: Use `--with-libnettle-prefix' on all platforms
          # Note: GMP is a dependency of Nettle, whose public headers include
          # GMP headers, hence the hack.
        then " --with-libnettle-prefix=${nettle} CPPFLAGS=-I${gmp}/include"
        else ""}
  '';

  buildInputs = [ zlib lzo ]
    ++ stdenv.lib.optional guileBindings guile;

  buildNativeInputs = [ perl ];

  propagatedBuildInputs = [ nettle libtasn1 ];

  # XXX: Gnulib's `test-select' fails on FreeBSD:
  # http://hydra.nixos.org/build/2962084/nixlog/1/raw .
  doCheck = (!stdenv.isFreeBSD);

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

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}

//

(stdenv.lib.optionalAttrs stdenv.isFreeBSD {
  # FreeBSD doesn't have <alloca.h>, and Gnulib's `alloca' module isn't used.
  patches = [ ./guile-gnulib-includes.patch ];
}))
