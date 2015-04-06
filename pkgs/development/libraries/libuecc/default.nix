{ stdenv, fetchgit, pkgs }:

stdenv.mkDerivation rec {
  version = "v5";
  name = "libuecc-${version}";

  src = fetchgit {
    url = "git://git.universe-factory.net/libuecc";
    rev = "refs/tags/${version}";
    sha256 = "1dac165cfd7e4ebe38fca6da256e3816a21f0c2dbe2f515ddb185f76687dabd5";
  };

  buildInputs = [];

  nativeBuildInputs = [ pkgs.cmake pkgs.pkgconfig pkgs.doxygen ];

  buildPhase = ''
    cmake -D CMAKE_BUILD_TYPE=RELEASE .
    make
  '';

  installPhase = ''
    make install
  '';

  meta = with stdenv.lib; {
    description = "Very small Elliptic Curve Cryptography library";
    license = stdenv.lib.licenses.bsd2;
    homepage = "http://git.universe-factory.net/libuecc/";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ maintainers.abaldeau ];
  };
}
