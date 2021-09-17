{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "crcpp";
  version = "1.1.0.0";

  src = fetchFromGitHub {
    owner = "d-bahr";
    repo = "CRCpp";
    rev = "release-${version}";
    sha256 = "sha256-jBvh4dHSFChxNPVgkGVHy3TXSExsfwdVUfsA8XB1cn8=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    cp inc/CRC.h $out/include
  '';

  meta = with lib; {
    homepage = "https://github.com/d-bahr/CRCpp";
    description = "Easy to use and fast C++ CRC library";
    platforms = platforms.all;
    maintainers = [ maintainers.ivar ];
    license = licenses.bsd3;
  };
}
