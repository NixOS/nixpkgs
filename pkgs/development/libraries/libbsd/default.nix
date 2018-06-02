{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libbsd-${version}";
  version = "0.9.1";

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1957w2wi7iqar978qlfsm220dwywnrh5m58nrnn9zmi74ds3bn2n";
  };

  patches = [];

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems, Freedesktop fork";
    homepage = https://libbsd.freedesktop.org/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
  };
}
