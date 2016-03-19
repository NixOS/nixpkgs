{ stdenv, fetchurl,
  bison, flex, expat, file
}:

stdenv.mkDerivation rec {
    name = "udunits-2.2.20";
    src = fetchurl {
        url = "ftp://ftp.unidata.ucar.edu/pub/udunits/${name}.tar.gz";
        sha256 = "15fiv66ni6fmyz96k138vrjd7cx6ndxrj6c71pah18n69c0h42pi";
    };

    buildInputs = [ bison flex expat file ];

    meta = with stdenv.lib; {
      homepage = http://www.unidata.ucar.edu/software/udunits/;
      description = "A C-based package for the programatic handling of units of physical quantities";
      license = licenses.bsdOriginal;
      platforms = platforms.linux;
      maintainers = with maintainers; [ pSub ];
    };
}
