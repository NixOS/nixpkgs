{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "libxls";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/libxls/libxls/releases/download/v${version}/libxls-${version}.tar.gz";
    sha256 = "1y7wk55blk16hmvf9dz5ci84hlhv6pw6mnr1mfnibfw3gsxmzhyv";
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
