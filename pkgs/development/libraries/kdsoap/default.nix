{
  stdenv,
  lib,
  fetchurl,
  cmake,
  qtbase,
  wrapQtAppsHook,
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
  cmakeName = if isQt6 then "KDSoap-qt6" else "KDSoap";
in
stdenv.mkDerivation rec {
  pname = "kdsoap";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/KDAB/KDSoap/releases/download/kdsoap-${version}/kdsoap-${version}.tar.gz";
    sha256 = "sha256-2e8RlIRCGXyfpEvW+63IQrcoCmDfxAV3r2b97WN681Y=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase ];

  cmakeFlags = [ (lib.cmakeBool "KDSoap_QT6" isQt6) ];

  postInstall = ''
    moveToOutput bin/kdwsdl2cpp* "$dev"
    substituteInPlace "$out/lib/cmake/${cmakeName}/KDSoapTargets-release.cmake" \
      --replace $out/bin $dev/bin
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Qt-based client-side and server-side SOAP component";
    longDescription = ''
      KD Soap is a Qt-based client-side and server-side SOAP component.

      It can be used to create client applications for web services and also
      provides the means to create web services without the need for any further
      component such as a dedicated web server.
    '';
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2
      gpl3
      lgpl21
    ];
<<<<<<< HEAD
    maintainers = [ lib.maintainers.ttuegel ];
=======
    maintainers = [ maintainers.ttuegel ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
