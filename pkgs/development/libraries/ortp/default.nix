{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ortp-0.24.1";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "1mach7cdq4kydqkll8ra1kir818da07z253rf9pihifipqhcxv6i";
  };

  meta = with stdenv.lib; {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
