{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "openslp-2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/openslp/2.0.0/2.0.0/openslp-2.0.0.tar.gz";
    sha256 = "16splwmqp0400w56297fkipaq9vlbhv7hapap8z09gp5m2i3fhwj";
  };

  meta = with stdenv.lib; {
    homepage = "http://openslp.org/";
    description = "An open-source implementation of the IETF Service Location Protocol";
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };

}
