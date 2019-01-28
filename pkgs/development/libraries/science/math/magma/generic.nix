{ version
, sha256
}:

{ stdenv, fetchurl, cmake, gfortran, cudatoolkit, libpthreadstubs
, mklSupport ? false, blas ? null, liblapack ? null, mkl ? null
}:

assert  mklSupport -> mkl != null;
assert !mklSupport -> blas != null && liblapack != null;

with stdenv.lib;

stdenv.mkDerivation {
  name = "magma-${version}";

  inherit version;

  src = fetchurl {
    url = "https://icl.cs.utk.edu/projectsfiles/magma/downloads/magma-${version}.tar.gz";
    inherit sha256;
    name = "magma-${version}.tar.gz";
  };

  buildInputs = [ gfortran cudatoolkit libpthreadstubs cmake ]
    ++ (if mklSupport then [mkl] else [blas liblapack]);

  doCheck = false;
  #checkTarget = "tests";

  cmakeFlags = stdenv.lib.optional mklSupport "-DMKLROOT=${mkl} -DMAGMA_WITH_MKL=true";

  enableParallelBuilding=true;

  # MAGMA's default CMake setup does not care about installation. So we copy files directly.
  installPhase = ''
    mkdir -p $out
    mkdir -p $out/include
    mkdir -p $out/lib
    mkdir -p $out/lib/pkgconfig
    cp -a ../include/*.h $out/include
    #cp -a sparse-iter/include/*.h $out/include
    cp -a lib/*.a $out/lib
    cat ../lib/pkgconfig/magma.pc.in                   | \
    sed -e s:@INSTALL_PREFIX@:"$out":          | \
    sed -e s:@CFLAGS@:"-I$out/include":    | \
    sed -e s:@LIBS@:"-L$out/lib -lmagma -lmagma_sparse": | \
    sed -e s:@MAGMA_REQUIRED@::                       \
        > $out/lib/pkgconfig/magma.pc
  '';

  meta = with stdenv.lib; {
    description = "Matrix Algebra on GPU and Multicore Architectures";
    license = licenses.bsd3;
    homepage = http://icl.cs.utk.edu/magma/index.html;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ianwookim ];
  };
}
