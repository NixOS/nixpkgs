{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "updfparser";
  version = "unstable-2023-01-10";
  rev = "a421098092ba600fb1686a7df8fc58cd67429f59";

  src = fetchzip {
    url = "https://indefero.soutade.fr/p/updfparser/source/download/${rev}/";
    sha256 = "sha256-Kt1QDj7E0GaT615kJW2MQKF9BeU5U7/95TQKODpxgNI=";
    extension = "zip";
  };

  makeFlags = [ "BUILD_STATIC=1" "BUILD_SHARED=1" ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/include include/*.h
    install -Dt $out/lib libupdfparser.so
    install -Dt $out/lib libupdfparser.a
    runHook postInstall
  '';

  meta = with lib; {
    description = "A very simple PDF parser";
    homepage = "https://indefero.soutade.fr/p/updfparser";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ autumnal ];
    platforms = platforms.all;
  };
}
