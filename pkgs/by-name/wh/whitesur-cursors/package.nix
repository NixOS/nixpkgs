{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "whitesur-cursors";
  version = "0-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-cursors";
    rev = "c8759f13de18612051e7c1250946f54e49128b61";
    hash = "sha256-xzqX/Xa+SEJ6t5T6LMe4m0RBcwioX2B/DHUa6kigzm4=";
  };

  installPhase = ''
    runHook preInstall
    install -dm 755 $out/share/icons/WhiteSur-cursors
    cp -r dist/* $out/share/icons/WhiteSur-cursors
    runHook postInstall
  '';

  meta = {
    description = "X-cursor theme inspired by macOS and based on capitaine-cursors";
    homepage = "https://github.com/vinceliuice/WhiteSur-cursors";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
}
