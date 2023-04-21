{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "restinio";
  version = "0.6.18";

  src = fetchurl {
    url = "https://github.com/Stiffstream/restinio/releases/download/v.${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-4OksmaW6NBpZ8npqLiZGn6zmCB7KxXlU5NKfKmA7Zr8=";
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
