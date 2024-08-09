{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "z64decompress";
  version = "1.0.3-unstable-2023-12-21";

  src = fetchFromGitHub {
    owner = "z64tools";
    repo = "z64decompress";
    rev = "e2b3707271994a2a1b3afc6c3997a7cf6b479765";
    hash = "sha256-PHiOeEB9njJPsl6ScdoDVwJXGqOdIIJCZRbIXSieBIY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin z64decompress

    runHook postInstall
  '';

  meta = {
    description = "Zelda 64 rom decompressor";
    homepage = "https://github.com/z64tools/z64decompress";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ qubitnano ];
    mainProgram = "z64decompress";
    platforms = lib.platforms.all;
  };
})
