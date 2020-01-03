{stdenv, fetchgit, luajit, openblas, imagemagick, cmake, curl, fftw, gnuplot
  , libjpeg, zeromq3, ncurses, openssl, libpng, qt4, readline, unzip
  , pkgconfig, zlib, libX11, which
  }:
stdenv.mkDerivation rec{
  version = "0.0pre20160820";
  pname = "torch";
  buildInputs = [
    luajit openblas imagemagick cmake curl fftw gnuplot unzip qt4
    libjpeg zeromq3 ncurses openssl libpng readline pkgconfig
    zlib libX11 which
  ];

  src = fetchgit {
    url = "https://github.com/torch/distro";
    rev = "8b6a834f8c8755f6f5f84ef9d8da9cfc79c5ce1f";
    sha256 = "120hnz82d7izinsmv5smyqww71dhpix23pm43s522dfcglpql8xy";
    fetchSubmodules = true;
  };

  buildPhase = ''
    cd ..
    export PREFIX=$out

    mkdir "$out"
    sh install.sh -s
  '';
  installPhase = ''
  '';
  meta = {
    inherit version;
    description = ''A scientific computing framework with wide support for machine learning algorithms'';
    license = stdenv.lib.licenses.bsd3 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
