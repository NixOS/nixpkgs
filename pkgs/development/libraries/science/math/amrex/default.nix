{ stdenv
, fetchFromGitHub
, python
, mpi
, gfortran
}:

stdenv.mkDerivation rec {
  name = "amrex-${version}";
  version = "19.04.2";

  src = fetchFromGitHub {
    owner = "AMReX-Codes";
    repo = "amrex";
    rev = version;
    sha256 = "0h22l4kmmblqvsy3rny5yp35fa13lhg3wn4b5fky0cqqwqwafzfd";
  };

  preConfigure = ''
    patchShebangs .
  '';

  buildInputs = [ python mpi gfortran ];

  meta = with stdenv.lib; {
    homepage = https://github.com/AMReX-Codes/amrex;
    description = "AMReX: Software Framework for Block Structured AMR";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
    platforms = platforms.linux;
  };
}
