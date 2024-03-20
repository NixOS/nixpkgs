{ lib, stdenv, fetchurl, gfortran, zlib }:

stdenv.mkDerivation rec {
  pname = "QCDNUM";
  version = "18-00-00";

  src = fetchurl {
    url = "http://www.nikhef.nl/user/h24/qcdnum-files/download/qcdnum${builtins.replaceStrings ["-"] [""] version}.tar.gz";
    hash = "sha256-4Qj5JreEA1LkCAunGRTTQD7YEYNk+HcQ4iH97DIO4gA=";
  };

  nativeBuildInputs = [ gfortran ];
  buildInputs = [ zlib ];

  FFLAGS = [
    "-std=legacy" # fix build with gfortran 10
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A very fast QCD evolution program written in FORTRAN77";
    mainProgram = "qcdnum-config";
    license     = lib.licenses.gpl3;
    homepage    = "https://www.nikhef.nl/~h24/qcdnum/index.html";
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
