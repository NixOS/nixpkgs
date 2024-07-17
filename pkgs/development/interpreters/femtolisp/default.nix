{
  lib,
  stdenv,
  fetchFromSourcehut,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "femtolisp";
  version = "0-unstable-2024-06-18";

  src = fetchFromSourcehut {
    owner = "~ft";
    repo = "femtolisp";
    rev = "ee58f398fec62d3096b0e01da51a3969ed37a32d";
    hash = "sha256-pfPD9TNLmrqhvJS/aVVmziMVApsiU5v1nAMqU+Kduzw=";
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
    description = "Compact interpreter for a minimal lisp/scheme dialect";
    homepage = "https://git.sr.ht/~ft/femtolisp";
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = with lib.maintainers; [ moody ];
    broken = stdenv.isDarwin;
    platforms = lib.platforms.unix;
    mainProgram = "flisp";
  };
}
