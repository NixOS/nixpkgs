{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "amf-headers";
  version = "1.4.30";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "AMF";
    rev = "v${version}";
    sha256 = "sha256-eShqo5EBbhl2Us4feFjiX+NfEl1OQ2jPQUC+Hlm+yFs=";
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
