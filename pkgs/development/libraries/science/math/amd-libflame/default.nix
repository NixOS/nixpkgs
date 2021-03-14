{ lib
, stdenv
, fetchFromGitHub
, gfortran
, python3
, amd-blis

, withOpenMP ? true
}:

stdenv.mkDerivation rec {
  pname = "amd-libflame";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "libflame";
    rev = version;
    sha256 = "1s8zvq6p843jb52lrbxra7vv0wzmifs4j36z9bp7wf3xr20a0zi5";
  };

  patches = [
    # The LAPACKE interface is compiled as a separate static library,
    # we want the main dynamic library to provide LAPACKE symbols.
    # This patch adds lapacke.a to the shared library as well.
    ./add-lapacke.diff
  ];

  nativeBuildInputs = [ gfortran python3 ];

  buildInputs = [ amd-blis ];

  configureFlags = [
    # Build a dynamic library with a LAPACK interface.
    "--disable-static-build"
    "--enable-dynamic-build"
    "--enable-lapack2flame"

    # Use C BLAS interface.
    "--enable-cblas-interfaces"

    # Avoid overloading maximum number of arguments.
    "--enable-max-arg-list-hack"

    # libflame by default leaves BLAS symbols unresolved and leaves it
    # up to the application to explicitly link to a BLAS. This is
    # problematic for us, since then the BLAS library becomes an
    # implicit dependency. Moreover, since the point of the AMD forks
    # is to optimized for recent AMD CPUs, link against AMD BLIS.
    "LDFLAGS=-lcblas"
  ]
  ++ lib.optionals withOpenMP [ "--enable-multithreading=openmp" ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs build
  '';

  postInstall = ''
    ln -s $out/lib/libflame.so.${version} $out/lib/liblapack.so.3
    ln -s $out/lib/libflame.so.${version} $out/lib/liblapacke.so.3
  '';

  meta = with lib; {
    description = "LAPACK-compatible linear algebra library optimized for AMD CPUs";
    homepage = "https://developer.amd.com/amd-aocl/blas-library/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danieldk ];
    platforms = [ "x86_64-linux" ];
  };
}
