{ stdenv, fetchurl, substituteAll
, atlasWithLapack, gfortran }:

let
  name = "suitesparse-4.4.1";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.4.1.tar.gz";
    sha256 = "0y8i6dizrr556xggpjyc7wijjv4jbizhssmjj4jv8n1s7zxy2z0n";
  };

  patches = [
    ./0001-disable-metis.patch
    ./0002-set-install-dir.patch
    (substituteAll {
      src = ./0003-blas-lapack-flags.patch;
      blasFlags = "-lf77blas -latlas -lcblas -lgfortran";
      lapackFlags= "-llapack -latlas -lcblas";
    })
  ];

  preConfigure = ''
    substituteAllInPlace SuiteSparse_config/SuiteSparse_config.mk
    mkdir -p $out/lib
    mkdir -p $out/include
  '';

  postInstall = ''
    # Install documentation
    outdoc=$out/share/doc/${name}
    mkdir -p $outdoc
    cp -r AMD/Doc $outdoc/amd
    cp -r BTF/Doc $outdoc/bft
    cp -r CAMD/Doc $outdoc/camd
    cp -r CCOLAMD/Doc $outdoc/ccolamd
    cp -r CHOLMOD/Doc $outdoc/cholmod
    cp -r COLAMD/Doc $outdoc/colamd
    cp -r CXSparse/Doc $outdoc/cxsparse
    cp -r KLU/Doc $outdoc/klu
    cp -r LDL/Doc $outdoc/ldl
    cp -r RBio/Doc $outdoc/rbio
    cp -r SPQR/Doc $outdoc/spqr
    cp -r UMFPACK/Doc $outdoc/umfpack
  '';

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ atlasWithLapack ];

  meta = with stdenv.lib; {
    homepage = http://faculty.cse.tamu.edu/davis/suitesparse.html;
    description = "A suite of sparse matrix algorithms";
    license = with licenses; [ bsd2 gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ttuegel ];
  };
}
