{
  lib,
  buildDunePackage,
  odiff-core,
  dune-configurator,
  libspng,
  libjpeg,
  libtiff,
}:

buildDunePackage {
  pname = "odiff-io";
  inherit (odiff-core) version src meta;

  buildInputs = [
    dune-configurator
    odiff-core
  ];

  preBuild = ''
    export LIBJPEG_CFLAGS="-I${lib.getDev libjpeg}/include"
    export LIBJPEG_LIBS="-L${lib.getLib libjpeg}/lib -ljpeg"
    export LIBPNG_CFLAGS="-I${lib.getDev libspng}/include"
    export LIBPNG_LIBS="-L${lib.getLib libspng}/lib -lspng"
    export LIBTIFF_CFLAGS="-I${lib.getDev libtiff}/include"
    export LIBTIFF_LIBS="-L${lib.getLib libtiff}/lib -ltiff"
  '';
}
