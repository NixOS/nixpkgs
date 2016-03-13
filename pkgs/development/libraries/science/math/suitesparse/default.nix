{ stdenv, fetchurl, gfortran, openblas }:

let
  version = "4.4.4";
  name = "suitesparse-${version}";

  int_t = if openblas.blas64 then "int64_t" else "int32_t";
  SHLIB_EXT = if stdenv.isDarwin then "dylib" else "so";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-${version}.tar.gz";
    sha256 = "1zdn1y0ij6amj7smmcslkqgbqv9yy5cwmbyzqc9v6drzdzllgbpj";
  };

  preConfigure = ''
    mkdir -p $out/lib
    mkdir -p $out/include

    sed -i "SuiteSparse_config/SuiteSparse_config.mk" \
        -e 's/METIS .*$/METIS =/' \
        -e 's/METIS_PATH .*$/METIS_PATH =/' \
        -e '/CHOLMOD_CONFIG/ s/$/-DNPARTITION -DLONGBLAS=${int_t}/' \
        -e '/UMFPACK_CONFIG/ s/$/-DLONGBLAS=${int_t}/'
  ''
  + stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i "SuiteSparse_config/SuiteSparse_config.mk" \
        -e 's/^[[:space:]]*\(LIB = -lm\) -lrt/\1/'
  '';

  makeFlags = [
    "PREFIX=\"$(out)\""
    "INSTALL_LIB=$(out)/lib"
    "INSTALL_INCLUDE=$(out)/include"
    "BLAS=-lopenblas"
    "LAPACK="
  ];

  NIX_CFLAGS = "-fPIC" + stdenv.lib.optionalString stdenv.isDarwin " -DNTIMER";

  postInstall = ''
    # Build and install shared library
    (
        cd "$(mktemp -d)"
        for i in "$out"/lib/lib*.a; do
          ar -x $i
        done
        ''${CC} *.o ${if stdenv.isDarwin then "-dynamiclib" else "--shared"} -o "$out/lib/libsuitesparse.${SHLIB_EXT}" -lopenblas
    )
    for i in umfpack cholmod amd camd colamd spqr; do
      ln -s libsuitesparse.${SHLIB_EXT} "$out"/lib/lib$i.${SHLIB_EXT}
    done

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
  buildInputs = [ openblas ];

  meta = with stdenv.lib; {
    homepage = http://faculty.cse.tamu.edu/davis/suitesparse.html;
    description = "A suite of sparse matrix algorithms";
    license = with licenses; [ bsd2 gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ ttuegel ];
  };
}
