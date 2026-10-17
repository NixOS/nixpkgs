{
  lib,
  stdenv,
  fetchFromSourcehut,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "uxncli";
  version = "1.0-unstable-2026-09-11";

  src = fetchFromSourcehut {
    owner = "~rabbits";
    repo = "uxncli";
    rev = "e3e49f62806d91cf8647efcd5dbcc4a0c861ab50";
    hash = "sha256-xpB6GRJck8krB3iUy9x3aO68t65Lnpym7hfEN6lBiBY=";
  };

  strictDeps = true;

  buildFlags = [ "bin/uxncli" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/uxncli $out/bin/uxncli
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://git.sr.ht/~rabbits/uxncli";
    description = "Partial Varvara Ordinator, written in C89";
    longDescription = ''
      A partial emulator for the Varvara Ordinator, written in ANSI C.

      This emulator has a limited features, it has just enough device support as to be capable of assembling roms with Drifblim.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vkluna ];
    mainProgram = "uxncli";
    platforms = lib.platforms.unix;
  };
})
