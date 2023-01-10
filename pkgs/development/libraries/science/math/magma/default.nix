{ lib, stdenv, fetchurl, cmake, gfortran, ninja, cudaPackages, libpthreadstubs, lapack, blas }:

let
  inherit (cudaPackages) cudatoolkit cudaFlags;
in

assert let majorIs = lib.versions.major cudatoolkit.version;
       in majorIs == "9" || majorIs == "10" || majorIs == "11";

let
  version = "2.6.2";

in stdenv.mkDerivation {
  pname = "magma";
  inherit version;
  src = fetchurl {
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
    hash = "sha256-dbVU2rAJA+LRC5cskT5Q5/iMvGLzrkMrWghsfk7aCnE=";
    name = "magma-${version}.tar.gz";
  };

  nativeBuildInputs = [ gfortran cmake ninja ];

  buildInputs = [ cudatoolkit libpthreadstubs lapack blas ];

  cmakeFlags = [
    "-DGPU_TARGET=${builtins.concatStringsSep "," cudaFlags.cudaRealArchs}"
  ];

  doCheck = false;

  preConfigure = ''
    export CC=${cudatoolkit.cc}/bin/gcc CXX=${cudatoolkit.cc}/bin/g++
  '';

  enableParallelBuilding=true;
  buildFlags = [ "magma" "magma_sparse" ];

  meta = with lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = "http://icl.cs.utk.edu/magma/index.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ tbenst ];
  };

  passthru.cudatoolkit = cudatoolkit;
}
