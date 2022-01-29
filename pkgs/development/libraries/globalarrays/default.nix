{ lib, stdenv, fetchpatch, fetchFromGitHub, autoreconfHook
, blas, gfortran, openssh, mpi
} :

stdenv.mkDerivation rec {
  pname = "globalarrays";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${version}";
    sha256 = "sha256-IyHdeIUHu/T4lb/etGGnNB2guIspual8/v9eS807Qco=";
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
