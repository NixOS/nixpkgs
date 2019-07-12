{ stdenv
, fetchFromGitHub
, cmake
, gfortran
, mpi
, blas
}:

stdenv.mkDerivation rec{
  version = "12-14-1";
  name = "trilinos";

  src = fetchFromGitHub {
    owner = "trilinos";
    repo = "Trilinos";
    rev = "trilinos-release-${version}";
    sha256 = "1366j3x0dszmlal9kswp24kw4bv47i7rf4j6hpngz0zd8zx087kn";
  };

  nativeBuildInputs = [ cmake gfortran ];

  buildInputs = [ blas ];

  cmakeFlags = [
    "-DTrilinos_ENABLE_ALL_PACKAGES=ON"
    "-DBLAS_LIBRARY_DIRS=${blas}/lib"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/trilinos/Trilinos;
    license = licenses.bsd3;
    description = "Object-oriented Solution of large-scale, complex multi-physics engineering and scientific problems";
    platforms = stdenv.lib.platforms.unix;
  };

}
