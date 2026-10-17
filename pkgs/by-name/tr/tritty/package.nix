{ callPackage, fetchFromGitHub, lib, stdenv }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tritty";
  # The number after + indicates the number of commits since the release.
  version = "1.0+12";
  src = fetchFromGitHub {
    owner = "sjmulder";
    repo = "trickle";
    rev = "57bbf836a232d931404b66938941b2571fdc716f";
    hash = "sha256-D9UCryE3+rODsP4rXVJrE2gL44EVSQ6fN3doQXJkbJE=";
  };
  makeFlags = [ "PREFIX=${builtins.placeholder "out"}" ];

  passthru = {
    tests = {
      simple = callPackage ./tests/simple.nix { tritty = finalAttrs.finalPackage; };
    };
  };

  meta = {
    description = "Slow pipe and terminal";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/sjmulder/trickle#readme";
    changelog = "https://github.com/sjmulder/trickle/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "tritty";
    longDescription = ''
      This package provides two programs: trickle and tritty.

      trickle is used as part of a shell pipeline and has very low throughput, hence the name: data trickles through the pipe.

      tritty ("trickle tty") spawns an interactive subterminal with very low throughput. It simulates the experience of using a terminal over a slow connection.

      This is useful for testing the robustness and efficiency of terminal applications. It can uncover problems such as excessive redraws of progress bars, or other inefficient use of the terminal.

      Note that upstream names the package "trickle", but that name was already taken by another package in Nixpkgs.
    '';
    # Arguably upstream would pick trickle as the main program, but we can't name it that; see longDescription.
    # So we pick tritty as the main program instead, for a consistent experience.
    maintainers = with lib.maintainers; [ roberth ];
    platforms = lib.platforms.unix;
  };
})
