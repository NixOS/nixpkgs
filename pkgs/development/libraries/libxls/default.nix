{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "libxls";
  version = "1.5.2";

  src = fetchurl {
    url = "https://github.com/libxls/libxls/releases/download/v${version}/libxls-${version}.tar.gz";
    sha256 = "1akadsyl10rp101ccjmrxr7933c3v641k377bn74jv6cdkcm4zld";
  };

  nativeBuildInputs = [ unzip ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Extract Cell Data From Excel xls files";
    homepage = https://sourceforge.net/projects/libxls/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
