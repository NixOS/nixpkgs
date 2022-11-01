{ lib, stdenv, fetchFromGitHub, autoreconfHook, gfortran, lhapdf, python3, zlib }:

stdenv.mkDerivation rec {
  pname = "apfel";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "scarrazza";
    repo = "apfel";
    rev = version;
    sha256 = "sha256-fRdJ+C92tEC75iUwP9Tmm/EswrlA52eUo5fBjfieH9o=";
  };

  # needed for aarch64-darwin
  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gfortran lhapdf python3 zlib ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A PDF Evolution Library";
    license     = licenses.gpl3Plus;
    homepage    = "https://apfel.mi.infn.it/";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
