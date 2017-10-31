{ stdenv, fetchurl,
  bison, flex, expat, file
}:

stdenv.mkDerivation rec {
    name = "udunits-2.2.24";
    src = fetchurl {
        url = "ftp://ftp.unidata.ucar.edu/pub/udunits/${name}.tar.gz";
        sha256 = "15bz2wv46wiwdzai8770gzy05prgj120x6j2hmihavv5y89cbfi0";
    };

    nativeBuildInputs = [ bison flex file ];
    buildInputs = [ expat ];

    meta = with stdenv.lib; {
      homepage = http://www.unidata.ucar.edu/software/udunits/;
      description = "A C-based package for the programatic handling of units of physical quantities";
      license = licenses.bsdOriginal;
      platforms = platforms.linux;
      maintainers = with maintainers; [ pSub ];
    };
}
