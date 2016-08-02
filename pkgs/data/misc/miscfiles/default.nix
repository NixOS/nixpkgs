{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "miscfiles-1.5";

  src = fetchurl {
    url = "mirror://gnu/miscfiles/${name}.tar.gz";
    sha256 = "005588vfrwx8ghsdv9p7zczj9lbc9a3r4m5aphcaqv8gif4siaka";
  };

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/miscfiles/;
    license = licenses.gpl2Plus;
    description = "Collection of files not of crucial importance for sysadmins";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
