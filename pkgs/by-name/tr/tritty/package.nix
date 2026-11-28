{
  callPackage,
  fetchFromCodeberg,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tritty";
  version = "1.0.1";
  src = fetchFromCodeberg {
    owner = "sjmulder";
    repo = "trickle";
    tag = finalAttrs.version;
    hash = "sha256-L8iYXM1GpmWcuQ1FV1cdWYVLGc1PoJbhBCM4DM8X3e4=";
  };
  makeFlags = [
    "PREFIX=${builtins.placeholder "out"}"
    "MANPREFIX=${builtins.placeholder "out"}/share/man"
  ];
  __structuredAttrs = true;
  strictDeps = true;

  passthru = {
    tests = {
      simple = callPackage ./tests/simple.nix { tritty = finalAttrs.finalPackage; };
    };
  };

  meta = {
    description = "Slow pipe and terminal";
    license = lib.licenses.bsd2;
    homepage = "https://codeberg.org/sjmulder/trickle#readme";
    changelog = "https://codeberg.org/sjmulder/trickle/src/tag/${finalAttrs.src.tag}/CHANGES.md";
    # Arguably upstream would pick trickle as the main program, but since our
    # package attribute is tritty (see longDescription), we pick tritty instead.
    mainProgram = "tritty";
    longDescription = ''
      This package provides two programs: trickle and tritty.

      trickle is used as part of a shell pipeline and has very low throughput, hence the name: data trickles through the pipe.

      tritty ("trickle tty") spawns an interactive subterminal with very low throughput. It simulates the experience of using a terminal over a slow connection.

      This is useful for testing the robustness and efficiency of terminal applications. It can uncover problems such as excessive redraws of progress bars, or other inefficient use of the terminal.

      Note that upstream names the package "trickle", but that name was already taken by another package in Nixpkgs.
    '';
    maintainers = with lib.maintainers; [ roberth ];
    platforms = lib.platforms.unix;
  };
})
