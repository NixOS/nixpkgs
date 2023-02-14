{ lib, stdenv, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, mpi, python3, petsc }:

stdenv.mkDerivation rec {
  pname = "libroadrunner-deps";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "sys-bio";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256:07lmrljpv5ycygwpdvg22ad6l78brvqzpgjrsfljxfjqnzbxlvpl";
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  hardeningDisable = [ "format" ];


  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost eigen libxml2 mpi python3 python3.pkgs.numpy ];

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    license = with lib.licenses; [ gpl3 ];
    homepage = "https://www.precice.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}

