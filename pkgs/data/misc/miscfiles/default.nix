{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "miscfiles-1.4.2";

  src = fetchurl {
    url = "mirror://gnu/miscfiles/${name}.tar.gz";
    sha256 = "1rh10y63asyrqyp5mlmxy7y4kdp6svk2inws3y7mfx8lsrhcm6dn";
  };

  meta = {
    homepage = http://www.gnu.org/software/miscfiles/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Collection of files not of crucial importance for sysadmins";
  };
}
