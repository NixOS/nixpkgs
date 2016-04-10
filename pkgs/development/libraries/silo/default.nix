{ stdenv, fetchurl
, mpich2, hdf5
, gfortran
, readline
, python, zlib
}:

stdenv.mkDerivation rec {
  name = "silo-${version}";

  version = "4.10.2";

  src = fetchurl {
    url = "https://wci.llnl.gov/content/assets/docs/simulation/computer-codes/silo/silo-4.10.2/silo-4.10.2-bsd.tar.gz";
    sha256 = "03hl40dy15n23mzsvpsfz0fs7ipnl8axwvws861nwrdl3vy1v42b";
  };

  configureFlags = [
    "--with-hdf=${hdf5}/include,${hdf5}/lib"
    "--enable-pythonmodule"
  ];

  buildInputs = [ mpich2 hdf5 gfortran readline python zlib ];

  meta = {
    homePage = "https://wci.llnl.gov/simulation/computer-codes/silo";
    description = "A Mesh and Field I/O Library and Scientific Database";
    license = "Copyright (c) 1994-2010, Lawrence Livermore National Security, LLC. All rights reserved. (https://wci.llnl.gov/simulation/computer-codes/silo/legacy_license)";
  };
}
