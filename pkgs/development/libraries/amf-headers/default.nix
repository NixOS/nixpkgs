{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "amf-headers";
<<<<<<< HEAD
  version = "1.4.30";
=======
  version = "1.4.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "AMF";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-eShqo5EBbhl2Us4feFjiX+NfEl1OQ2jPQUC+Hlm+yFs=";
=======
    sha256 = "sha256-gu8plGUUVE/De2bRjTUN8JKsmj/0r/IsqhMpln1DZGU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
