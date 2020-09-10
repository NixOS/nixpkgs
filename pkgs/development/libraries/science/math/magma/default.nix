{ stdenv, fetchurl, cmake, gfortran, ninja, cudatoolkit, libpthreadstubs, lapack, blas }:

with stdenv.lib;

let version = "2.5.3";

in stdenv.mkDerivation {
  pname = "magma";
  inherit version;
  src = fetchurl {
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
    sha256 = "1xjy3irdx0w1zyhvn4x47zni5fwsh6z97xd4yqldz8zrm5lx40n6";
    name = "magma-${version}.tar.gz";
  };

  nativeBuildInputs = [ gfortran cmake ninja ];

  buildInputs = [ cudatoolkit libpthreadstubs lapack blas ];

  doCheck = false;

  preConfigure = ''
    export CC=${cudatoolkit.cc}/bin/gcc CXX=${cudatoolkit.cc}/bin/g++
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ tbenst ];
  };
}
