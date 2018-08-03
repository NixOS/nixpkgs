{ stdenv, pkgs, fetchFromGitHub, automake, autoconf, libtool
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

  nativeBuildInputs = [ automake autoconf libtool ];
  buildInputs = [ openmpi openblas gfortran openssh ];

  preConfigure = ''
    autoreconf -ivf
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


