{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "libxls";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/libxls/libxls/releases/download/v${version}/libxls-${version}.tar.gz";
    sha256 = "0dam8qgbc5ykzaxmrjhpmfm8lnlcdk6cbpzyaya91qwwa80qbj1v";
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
