{ stdenv, fetchurl,
  bison, flex, expat, file
}:

stdenv.mkDerivation rec {
    name = "udunits-2.2.26";
    src = fetchurl {
        url = "ftp://ftp.unidata.ucar.edu/pub/udunits/${name}.tar.gz";
        sha256 = "0v9mqw4drnkzkm57331ail6yvs9485jmi37s40lhvmf7r5lli3rn";
    };

    nativeBuildInputs = [ bison flex file ];
    buildInputs = [ expat ];

    meta = with stdenv.lib; {
      homepage = https://www.unidata.ucar.edu/software/udunits/;
      description = "A C-based package for the programatic handling of units of physical quantities";
      license = licenses.bsdOriginal;
      platforms = platforms.linux;
      maintainers = with maintainers; [ pSub ];
    };
}
