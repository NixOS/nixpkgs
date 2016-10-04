{ stdenv, fetchurl, autoreconfHook, unzip }:

stdenv.mkDerivation rec {
  version = "2.5.0";
  name = "xlslib-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/xlslib/xlslib-package-${version}.zip";
    sha256 = "1wx3jbpkz2rvgs45x6mwawamd1b2llb0vn29b5sr0rfxzx9d1985";
  };

  nativeBuildInputs = [ unzip autoreconfHook ];

  setSourceRoot = "export sourceRoot=xlslib/xlslib";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++/C library to construct Excel .xls files in code";
    homepage = http://sourceforge.net/projects/xlslib/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
