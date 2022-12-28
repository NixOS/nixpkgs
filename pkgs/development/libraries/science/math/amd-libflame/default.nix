{ lib
, stdenv
, fetchFromGitHub
, gfortran
, python3
, amd-blis

, withOpenMP ? true
, blas64 ? false
}:

# right now only LP64 is supported
assert !blas64;

stdenv.mkDerivation rec {
  pname = "amd-libflame";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "libflame";
    rev = version;
    hash = "sha256-jESae5NqANw90RBbIHH2oGEq5/mudc4IONv50P/AeQ0=";
  };

  patches = [
    # The LAPACKE interface is compiled as a separate static library,
    # we want the main dynamic library to provide LAPACKE symbols.
    # This patch adds lapacke.a to the shared library as well.
    ./add-lapacke.diff
  ];

  passthru = { inherit blas64; };

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
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
