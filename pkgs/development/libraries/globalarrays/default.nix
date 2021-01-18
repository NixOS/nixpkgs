{ stdenv, fetchpatch, fetchFromGitHub, autoreconfHook
, blas, gfortran, openssh, openmpi
} :

let
  version = "5.8";

in stdenv.mkDerivation {
  pname = "globalarrays";
  inherit version;

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${version}";
    sha256 = "0bky91ncz6vy0011ps9prsnq9f4a5s5xwr23kkmi39xzg0417mnd";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openmpi blas gfortran openssh ];

  preConfigure = ''
    configureFlagsArray+=( "--enable-i8" \
                           "--with-mpi" \
                           "--with-mpi3" \
                           "--enable-eispack" \
                           "--enable-underscoring" \
                           "--with-blas8=${blas}/lib -lblas" )
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Global Arrays Programming Models";
    homepage = "http://hpc.pnl.gov/globalarrays/";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
