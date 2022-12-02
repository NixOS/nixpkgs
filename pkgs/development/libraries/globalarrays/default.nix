{ lib, stdenv, fetchpatch, fetchFromGitHub, autoreconfHook
, blas, gfortran, openssh, mpi
} :

stdenv.mkDerivation rec {
  pname = "globalarrays";
  version = "5.8.2";

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${version}";
    sha256 = "sha256-2ffQIg9topqKX7ygnWaa/UunL9d0Lj9qr9xucsjLuoY=";
  };

  nativeBuildInputs = [ autoreconfHook gfortran ];
  buildInputs = [ mpi blas openssh ];

  preConfigure = ''
    configureFlagsArray+=( "--enable-i8" \
                           "--with-mpi" \
                           "--with-mpi3" \
                           "--enable-eispack" \
                           "--enable-underscoring" \
                           "--with-blas8=${blas}/lib -lblas" )
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Global Arrays Programming Models";
    homepage = "http://hpc.pnl.gov/globalarrays/";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
