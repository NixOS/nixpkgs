{ lib
, stdenv
, fetchFromSourcehut
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "femtolisp";
  version = "unstable-2023-07-12";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "femtolisp";
    rev = "b3a21a0ff408e559639f6c31e1a2ab970787567f";
    hash = "sha256-PE/xYhfhn0xv/kJWsS07fOF2n5sXP666vy7OVaNxc7Y=";
  };

  strictDeps = true;

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin/ flisp

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A compact interpreter for a minimal lisp/scheme dialect";
    homepage = "https://git.sr.ht/~ft/femtolisp";
    license = with lib.licenses; [ mit bsd3 ];
    maintainers = with lib.maintainers; [ moody ];
    broken = stdenv.isDarwin;
    platforms = lib.platforms.unix;
    mainProgram = "flisp";
  };
}
