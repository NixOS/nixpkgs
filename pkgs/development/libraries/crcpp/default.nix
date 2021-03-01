{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "crcpp";
  version = "1.0.1.0";

  src = fetchFromGitHub {
    owner = "d-bahr";
    repo = "CRCpp";
    rev = "release-${version}";
    sha256 = "138w97kfxnv8rcnvggba6fcxgbgq8amikkmy3jhqfn6xzy6zaimh";
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
