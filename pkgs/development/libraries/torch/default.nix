{stdenv, fetchgit, luajit, openblas, imagemagick, cmake, curl, fftw, gnuplot
  , libjpeg, zeromq3, ncurses, openssl, libpng, qt4, readline, unzip
  , pkgconfig, zlib, libX11, which
  }:
stdenv.mkDerivation rec{
  version = "0.0pre20160820";
  name = "torch-${version}";
  buildInputs = [
    luajit openblas imagemagick cmake curl fftw gnuplot unzip qt4
    libjpeg zeromq3 ncurses openssl libpng readline pkgconfig
    zlib libX11 which
  ];
  src = fetchgit (stdenv.lib.importJSON ./src.json);
  buildPhase = ''
    cd ..
    export PREFIX=$out

    include=
    for i in $NIX_CFLAGS_COMPILE; do
      if test -n "$include" && test -d "$i"; then
        export CMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH''${CMAKE_INCLUDE_PATH:+:}$i"
      fi;
      if test "x$i" = "x-isystem"; then
        include=1
      else
        include=
      fi
    done

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
