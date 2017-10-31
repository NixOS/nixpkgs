{ stdenv, fetchurl, sqlite }:

stdenv.mkDerivation rec{
  name = "libchewing-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/chewing/libchewing/releases/download/v${version}/libchewing-${version}.tar.bz2";
    sha256 = "1j5g5j4w6yp73k03pmsq9n2r0p458hqriq0sd5kisj9xrssbynp5";
  };

  buildInputs = [ sqlite ];

  meta = with stdenv.lib; {
    description = "Intelligent Chinese phonetic input method";
    homepage = http://chewing.im/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.ericsagnes ];
    platforms = platforms.linux;
  };
}
