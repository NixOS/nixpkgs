{ fetchurl, stdenv, zlib, lzo, libtasn1, nettle
, guileBindings, guile, pkgconfig }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {

  name = "gnutls-2.12.9";

  src = fetchurl {
    url = "mirror://gnu/gnutls/${name}.tar.bz2";
    sha256 = "0ilfdyw6xr0w57aygmw1fvx56x2zh5la01y8bkx59crq927wk8bl";
  };

  configurePhase = ''
    ./configure --prefix="$out"                                 \
      --disable-dependency-tracking --enable-fast-install       \
      --with-lzo --with-libtasn1-prefix="${libtasn1}"		\
      --without-p11-kit                                         \
      ${if guileBindings
        then "--enable-guile --with-guile-site-dir=\"$out/share/guile/site\""
        else ""}
  '';

  buildInputs = [ zlib lzo libtasn1 pkgconfig ]
    ++ stdenv.lib.optional guileBindings guile;

  propagatedBuildInputs = [ nettle ];

  doCheck = true;

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
