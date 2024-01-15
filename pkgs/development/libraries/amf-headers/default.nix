{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "amf-headers";
  version = "1.4.32";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "AMF";
    rev = "v${version}";
    sha256 = "sha256-3CdC/9o6ur2CeVLImz2QfaZAH2+KtDdxs5zRF7W5/oo=";
  };

  installPhase = ''
    mkdir -p $out/include/AMF
    cp -r amf/public/include/* $out/include/AMF
  '';

  meta = with lib; {
    description = "Headers for The Advanced Media Framework (AMF)";
    homepage = "https://github.com/GPUOpen-LibrariesAndSDKs/AMF";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.unix;
  };
}
