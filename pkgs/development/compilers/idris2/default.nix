{ stdenv
, lib
, chez
, chez-racket
, clang
, gmp
, fetchFromGitHub
, makeWrapper
, gambit
, nodejs
, zsh
, callPackage
}:

let
  idris2-version = "0.5.1";  # When updating this, remove postInstall override below

  idris2-src = fetchFromGitHub {
    owner = "idris-lang";
    repo = "Idris2";
    rev = "v${idris2-version}";
    sha256 = "sha256-6CTn8o5geWSesXO7vTrrV/2EOQ3f+nPQ2M5cem13ZSY=";
  };

  idris2-derivation = callPackage "${idris2-src}/nix/package.nix" {
    inherit idris2-version;
    srcRev = "dirty";
    # This is taken from idris2/flake.nix. Check every now and then
    # if they still do the same thing.
    chez = if stdenv.isLinux then chez else chez-racket;
  };

  # Backport of fix for macOS as tracked in github issue #150521
  # The override of postInstall can be removed as soon as idris2-version
  # is larger than 0.5.1
  # To do this, just remove the definition of idirs2-derivation-backport-fix
  # and replace it with idris2-derivation in the "in" expression below.
  idris2-derivation-backport-fix = idris2-derivation.overrideAttrs (attrs: {
    postInstall = let
      name = idris2-derivation.name;

      globalLibraries = [
        "\\$HOME/.nix-profile/lib/${name}"
        "/run/current-system/sw/lib/${name}"
        "$out/${name}"
      ];
      globalLibrariesPath = builtins.concatStringsSep ":" globalLibraries;
    in ''
      # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
      rm $out/bin/idris2
      # The only thing we need from idris2_app is the actual binary
      mv $out/bin/idris2_app/idris2.so $out/bin/idris2
      rm $out/bin/idris2_app/*
      rmdir $out/bin/idris2_app
      # idris2 needs to find scheme at runtime to compile
      # idris2 installs packages with --install into the path given by
      #   IDRIS2_PREFIX. We set that to a default of ~/.idris2, to mirror the
      #   behaviour of the standard Makefile install.
      # TODO: Make support libraries their own derivation such that
      #       overriding LD_LIBRARY_PATH is unnecessary
      wrapProgram "$out/bin/idris2" \
        --set-default CHEZ "${chez}/bin/scheme" \
        --run 'export IDRIS2_PREFIX=''${IDRIS2_PREFIX-"$HOME/.idris2"}' \
        --suffix IDRIS2_LIBS ':' "$out/${name}/lib" \
        --suffix IDRIS2_DATA ':' "$out/${name}/support" \
        --suffix IDRIS2_PACKAGE_PATH ':' "${globalLibrariesPath}" \
        --suffix DYLD_LIBRARY_PATH ':' "$out/${name}/lib" \
        --suffix LD_LIBRARY_PATH ':' "$out/${name}/lib"
    '';
  });
in idris2-derivation-backport-fix // {
  meta = {
    description = "A purely functional programming language with first class types";
    homepage = "https://github.com/idris-lang/Idris2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fabianhjr wchresta ];
    platforms = lib.subtractLists chez.meta.platforms lib.platforms.aarch64;
  };

  # Run package tests
  tests = callPackage ./tests.nix { pname = idris2-derivation.pname; };
}

