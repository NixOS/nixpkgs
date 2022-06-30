{ lib, stdenv, fetchgit, fetchurl
, pugixml, updfparser, curl, openssl, libzip }:

let
  base64 = fetchurl {
    url = "https://gist.githubusercontent.com/tomykaira/f0fd86b6c73063283afe550bc5d77594/raw/7d5a89229a525452e37504976a73c35fbaf2fe4d/Base64.h";
    sha256 = "sha256-BKK+6mPEEEd4Y8c6GU2X6UB5fQ+3nPbUbEF8zQ6nGM4=";
  };
in stdenv.mkDerivation rec {
  name = "gourou";
  version = "0.7.2";

  src = fetchgit {
    url = "git://soutade.fr/libgourou";
    rev = "v${version}";
    sha256 = "sha256-jvvfrCuRggSPk7p/WtEaKRV7kILuZjUB1KEgaE4LStc=";
  };

  postUnpack = ''
    cp ${base64} $sourceRoot/include/base64.h
  '';

  patches = [
    ./base64.patch # vendor base64 header file
    ./devendor.patch # devendor pugixml and updfparser
  ];

  buildInputs = [ pugixml updfparser curl openssl libzip ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/include include/libgourou*.h
    install -Dt $out/lib libgourou.so
    install -Dt $out/bin utils/acsmdownloader
    install -Dt $out/bin utils/adept_{activate,loan_mgt,remove}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Implementation of Adobe's ADEPT protocol for ePub/PDF DRM";
    homepage = "https://indefero.soutade.fr/p/libgourou";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
