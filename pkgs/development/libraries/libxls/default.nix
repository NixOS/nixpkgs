{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "libxls-1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/libxls/${name}.zip";
    sha256 = "1g8ds7wbhsa4hdcn77xc2c0l3vvz5bx2hx9ng9c9n7aii92ymfnk";
  };

  nativeBuildInputs = [ unzip ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Extract Cell Data From Excel xls files";
    homepage = http://sourceforge.net/projects/libxls/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
