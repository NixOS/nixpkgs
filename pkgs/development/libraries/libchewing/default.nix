{ stdenv, fetchurl, sqlite }:

stdenv.mkDerivation rec{
  name = "libchewing-${version}";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/chewing/libchewing/releases/download/v${version}/libchewing-${version}.tar.bz2";
    sha256 = "0aqp2vqgxczydpn7pxi7r6xf3l1hgl710f0gbi1k8q7s2lscc24p";
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
