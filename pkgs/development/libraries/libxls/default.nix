{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "libxls";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/libxls/libxls/releases/download/v${version}/libxls-${version}.tar.gz";
    sha256 = "1m3acryv0l4zkj0w3h8vf23rfklschqcbaf484qms2lrx8gakvws";
  };

  nativeBuildInputs = [ unzip ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Extract Cell Data From Excel xls files";
    homepage = "https://sourceforge.net/projects/libxls/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
