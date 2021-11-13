{ lib, stdenv, fetchpatch, fetchFromGitHub, autoreconfHook
, blas, gfortran, openssh, mpi
} :

stdenv.mkDerivation rec {
  pname = "globalarrays";
  version = "5.8";

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${version}";
    sha256 = "0bky91ncz6vy0011ps9prsnq9f4a5s5xwr23kkmi39xzg0417mnd";
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
