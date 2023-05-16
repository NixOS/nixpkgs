{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "restinio";
<<<<<<< HEAD
  version = "0.6.19";

  src = fetchurl {
    url = "https://github.com/Stiffstream/restinio/releases/download/v.${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-fyHuvrlm4XDWq1TpsZiskn1DkJASFzngN8D6O7NnskA=";
=======
  version = "0.6.18";

  src = fetchurl {
    url = "https://github.com/Stiffstream/restinio/releases/download/v.${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-4OksmaW6NBpZ8npqLiZGn6zmCB7KxXlU5NKfKmA7Zr8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    mv restinio-*/dev/restinio $out/include

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform, efficient, customizable, and robust asynchronous HTTP/WebSocket server C++14 library";
    homepage = "https://github.com/Stiffstream/restinio";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
