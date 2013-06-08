{stdenv, fetchurl, gsasl, gnutls, pkgconfig, zlib, libtasn1, libgcrypt }:

stdenv.mkDerivation {
  name = "vmime-0.9.2svn";
  src = fetchurl {
    url = http://download.zarafa.com/community/final/7.0/7.0.5-31880/sourcecode/libvmime-0.9.2+svn603.tar.bz2;
    #url = mirror://sourceforge/vmime/libvmime-0.9.1.tar.bz2;
    sha256 = "1jhxiy8c2cgzfjps0z4q40wygdpgm8jr7jn727cbzrscj2c48kxx";
  };

  buildInputs = [ gsasl gnutls pkgconfig zlib libtasn1 libgcrypt ];

  meta = {
    homepage = http://www.vmime.org/;
    description = "Free mail library for C++";
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
