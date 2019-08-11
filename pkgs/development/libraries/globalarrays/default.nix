{ stdenv, fetchpatch, fetchFromGitHub, autoreconfHook
, openblas, gfortran, openssh, openmpi
} :

let
  version = "5.7";

in stdenv.mkDerivation {
  name = "globalarrays-${version}";

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${version}";
    sha256 = "07i2idaas7pq3in5mdqq5ndvxln5q87nyfgk3vzw85r72c4fq5jh";
  };

  # upstream patches for openmpi-4 compatibility
  patches = [ (fetchpatch {
    name = "MPI_Type_struct-was-deprecated-in-MPI-2";
    url = "https://github.com/GlobalArrays/ga/commit/36e6458993b1df745f43b7db86dc17087758e0d2.patch";
    sha256 = "058qi8x0ananqx980p03yxpyn41cnmm0ifwsl50qp6sc0bnbnclh";
  })
  (fetchpatch {
    name = "MPI_Errhandler_set-was-deprecated-in-MPI-2";
    url = "https://github.com/GlobalArrays/ga/commit/f1ea5203d2672c1a1d0275a012fb7c2fb3d033d8.patch";
    sha256 = "06n7ds9alk5xa6hd7waw3wrg88yx2azhdkn3cjs2k189iw8a7fqk";
  })];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openmpi openblas gfortran openssh ];

  preConfigure = ''
    configureFlagsArray+=( "--enable-i8" \
                           "--with-mpi" \
                           "--with-mpi3" \
                           "--enable-eispack" \
                           "--enable-underscoring" \
                           "--with-blas8=${openblas}/lib -lopenblas" )
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Global Arrays Programming Models";
    homepage = http://hpc.pnl.gov/globalarrays/;
    maintainers = [ maintainers.markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}


