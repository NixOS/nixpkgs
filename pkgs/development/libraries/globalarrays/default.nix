{ stdenv, fetchpatch, fetchFromGitHub, autoreconfHook
, openblas, gfortran, openssh, openmpi
} :

let
  version = "5.7.2";

in stdenv.mkDerivation {
  pname = "globalarrays";
  inherit version;

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${version}";
    sha256 = "0c1y9a5jpdw9nafzfmvjcln1xc2gklskaly0r1alm18ng9zng33i";
  };

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
    homepage = "http://hpc.pnl.gov/globalarrays/";
    maintainers = [ maintainers.markuskowa ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}


