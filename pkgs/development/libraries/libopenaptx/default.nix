{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libopenaptx-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "libopenaptx";
    rev = version;
    sha256 = "0996qmkmbax7ccknxrd3bx8xibs79a1ffms69scsj59f3kgj6854";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Audio Processing Technology codec (aptX)";
    license = licenses.lgpl21Plus;
    homepage = https://github.com/pali/libopenaptx;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
