{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "miscfiles";
  version = "1.5";

  src = fetchurl {
    url = "mirror://gnu/miscfiles/miscfiles-${version}.tar.gz";
    sha256 = "005588vfrwx8ghsdv9p7zczj9lbc9a3r4m5aphcaqv8gif4siaka";
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/miscfiles/";
    license = licenses.gpl2Plus;
    description = "Collection of files not of crucial importance for sysadmins";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
