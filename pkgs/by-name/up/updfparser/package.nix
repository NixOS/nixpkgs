{
  lib,
  stdenv,
  fetchFromGitea,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "updfparser";
  version = "0-unstable-2024-03-24";
  rev = "6060d123441a06df699eb275ae5ffdd50409b8f3";

  src = fetchFromGitea {
    inherit (finalAttrs) rev;
    domain = "forge.soutade.fr";
    owner = "soutade";
    repo = "updfparser";
    hash = "sha256-HD73WGZ4e/3T7vQmwU/lRADtvsInFG62uqvJmF773Rk=";
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
    homepage = "https://forge.soutade.fr/soutade/updfparser";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ autumnal ];
    platforms = platforms.all;
  };
})
