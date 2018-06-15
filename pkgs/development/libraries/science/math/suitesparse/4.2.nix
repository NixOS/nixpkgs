{ stdenv, fetchurl, gfortran, openblas }:

let
  int_t = if openblas.blas64 then "int64_t" else "int32_t";
in
stdenv.mkDerivation rec {
  version = "4.2.1";
  name = "suitesparse-${version}";
  src = fetchurl {
    url = "http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-${version}.tar.gz" ;
    sha256 = "1ga69637x7kdkiy3w3lq9dvva7220bdangv2lch2wx1hpi83h0p8";
  };

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ openblas ];

  preConfigure = ''
    mkdir -p $out/lib
    mkdir -p $out/include

    sed -i "SuiteSparse_config/SuiteSparse_config.mk" \
        -e 's/METIS .*$/METIS =/' \
        -e 's/METIS_PATH .*$/METIS_PATH =/' \
        -e '/CHOLMOD_CONFIG/ s/$/-DNPARTITION -DLONGBLAS=${int_t}/' \
        -e '/UMFPACK_CONFIG/ s/$/-DLONGBLAS=${int_t}/'
  '';

  makeFlags = [
    "PREFIX=\"$(out)\""
    "INSTALL_LIB=$(out)/lib"
    "INSTALL_INCLUDE=$(out)/include"
    "BLAS=-lopenblas"
    "LAPACK="
  ];

  meta = with stdenv.lib; {
    homepage = http://faculty.cse.tamu.edu/davis/suitesparse.html;
    description = "A suite of sparse matrix algorithms";
    license = with licenses; [ bsd2 gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; unix;
  };
}
