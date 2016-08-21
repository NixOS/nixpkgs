{stdenv, fetchgit, luajit, openblas, imagemagick, cmake, curl, fftw, gnuplot,
  libjpeg_turbo, zeromq3, ncurses, openssl, libpng, qt4, readline, unzip}:
stdenv.mkDerivation rec{
  version = "0.0pre20160820";
  name = "torch-${version}";
  buildInputs = [
    luajit openblas imagemagick cmake curl fftw gnuplot unzip qt4
    libjpeg_turbo zeromq3 ncurses openssl libpng readline
  ];
  src = fetchgit (stdenv.lib.importJSON ./src.json);
  configurePhase = ''
  '';
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
  };
}
