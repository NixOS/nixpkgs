{ stdenv
, fetchFromGitHub
, cmake
, mpi
, gfortran
}:

stdenv.mkDerivation rec {
  name = "hypre-${version}";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "hypre-space";
    repo = "hypre";
    rev = "v${version}";
    sha256 = "1gha571flc6q513137q4416hzpzb6qn2b9hlp3swik5150m91bbb";
  };

  preConfigure = ''
    cd src
    asdfasdfasdfasdf # intentionally fail build
  '';

  buildInputs = [ mpi gfortran cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/hypre-space/hypre;
    description = "Library for preconditioners and solvers featuring multigrid methods for the solution of large, sparse linear systems of equations";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ costrouc ];
    platforms = platforms.linux;
  };
}
