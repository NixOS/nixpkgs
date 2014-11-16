{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  version = "2.4.0";
  name = "xlslib-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/xlslib/xlslib-package-${version}.zip";
    sha256 = "0h7qhxcc55cz3jvrfv4scjnzf5w9g97wigyviandi4ag54qjxjdc";
  };

  nativeBuildInputs = [ unzip ];

  setSourceRoot = "export sourceRoot=xlslib/xlslib";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++/C library to construct Excel .xls files in code";
    homepage = http://xlslib.sourceforge.net/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = maintainers.abbradar;
  };
}
