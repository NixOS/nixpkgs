{stdenv, fetchurl, gsasl, gnutls, pkgconfig, zlib, libtasn1 }:

stdenv.mkDerivation {
  name = "vmime-0.9.1";
  src = fetchurl {
    url = mirror://sourceforge/vmime/libvmime-0.9.1.tar.bz2;
    sha256 = "1bninkznn07zhl7gc3jnigzvb0x1sclwqwgjy47ahzdwv5vcnriv";
  };

  buildInputs = [ gsasl gnutls pkgconfig zlib libtasn1 ];

  meta = {
    homepage = http://www.vmime.org/;
    description = "Free mail library for C++";
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
