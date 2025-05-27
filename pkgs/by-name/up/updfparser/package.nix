{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  name = "updfparser";
  version = "unstable-2023-08-08";
  rev = "c5ce75b9eea8ebb2746b13eeb0f335813c615115";

  src = fetchzip {
    hash = "sha256-RT7mvu43Izp0rHhKq4wR4kt0TDfzHvB2NGMR+fxO5UM=";
    url = "https://forge.soutade.fr/soutade/updfparser/archive/${rev}.tar.gz";
  };

  makeFlags = [
    "BUILD_STATIC=1"
    "BUILD_SHARED=1"
  ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/include include/*.h
    install -Dt $out/lib libupdfparser.so
    install -Dt $out/lib libupdfparser.a
    runHook postInstall
  '';

  meta = with lib; {
    description = "Very simple PDF parser";
    homepage = "https://indefero.soutade.fr/p/updfparser";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ autumnal ];
    platforms = platforms.all;
  };
}
