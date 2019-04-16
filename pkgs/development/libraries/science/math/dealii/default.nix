{ stdenv
, fetchFromGitHub
, cmake
, mpi
}:

stdenv.mkDerivation rec {
  name = "dealii-${version}";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "dealii";
    repo = "dealii";
    rev = "v${version}";
    sha256 = "01vz85fcm092bkbk4ib356j80b2hdwcxykkrhyrkw2pbas2npvnf";
  };

  buildInputs = [ cmake mpi ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dealii/dealii;
    description = "Computational solution of partial differential equations using adaptive finite elements";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ costrouc ];
    platforms = platforms.linux;
  };
}
