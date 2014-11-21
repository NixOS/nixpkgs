{ stdenv, fetchurl,
  bison, flex, expat, file
}:

stdenv.mkDerivation rec {
    name = "udunits-2.1.24";
    src = fetchurl {
        url = "ftp://ftp.unidata.ucar.edu/pub/udunits/${name}.tar.gz";
        sha256 = "1l0fdsl55374w7fjyd1wdx474f3p265b6rw1lq269cii61ca8prf";
    };

    buildInputs = [
        bison flex expat file
    ];

    patches = [ ./configure.patch ];

    MAGIC_CMD="${file}/bin/file";
}
