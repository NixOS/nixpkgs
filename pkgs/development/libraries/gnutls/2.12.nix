{ fetchurl, stdenv, zlib, lzo, libtasn1, nettle
, guileBindings, guile, pkgconfig, perl }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {

  name = "gnutls-2.12.23";

  src = fetchurl { # missing on standard mirrors
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v2.12/${name}.tar.bz2";
    sha256 = "1lkys703z4yxfgzarmgas5ccvn6m254w9wvm7s8v0zkj81z7m9nz";
  };

  patches = [(fetchurl {
    url = "http://anonscm.debian.org/viewvc/pkg-gnutls/packages/gnutls26/trunk/"
      + "debian/patches/21_sanitycheck.diff?revision=1777&view=co";
    sha256 = "0k18a7q6irmgjzp647bd18zccjpsr82n2s9arpamnkakgnny4ks9";
    name = "CVE-2013-2116.patch";
  })];

  configurePhase = ''
    patchShebangs .

    ./configure --prefix="$out"                                 \
      --disable-dependency-tracking --enable-fast-install       \
      --with-lzo --with-libtasn1-prefix="${libtasn1}"		\
      --without-p11-kit                                         \
      ${if guileBindings
        then "--enable-guile --with-guile-site-dir=\"$out/share/guile/site\""
        else ""}
  '';

  buildInputs = [ zlib lzo libtasn1 pkgconfig perl ]
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

    maintainers = [ ];
  };
}
