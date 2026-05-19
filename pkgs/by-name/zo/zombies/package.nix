{
  lib,
  fetchurl,
  stdenv,
  clisp,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zombies";
  version = "0-unstable-2006-03-07";

  src = fetchurl {
    url = "https://distractionandnonsense.com/zombies/zombies.lisp";
    hash = "sha256-g2CkdGUlTYB5V3chZIhm8IwkxJkICkER6h80wcHVNmU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/zombies/zombies.lisp

    makeWrapper ${clisp}/bin/clisp $out/bin/zombies \
      --add-flags "$out/share/zombies/zombies.lisp"

    runHook postInstall
  '';

  meta = {
    description = "Minimalist Common Lisp Zombies rougelike";
    homepage = "https://distractionandnonsense.com/zombies/";
    mainProgram = "zombies";
    #The game is released under joke Zombie Public License (ZPL).
    #This means you can use the code for anything you like.
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
