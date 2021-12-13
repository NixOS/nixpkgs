{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, clang
, chez
, gmp
, zsh
}:

# NOTICE: An `idris2WithPackages` is available at: https://github.com/claymager/idris2-pkgs

# Uses scheme to bootstrap the build of idris2
stdenv.mkDerivation rec {
  pname = "idris2";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "idris-lang";
    repo = "Idris2";
    rev = "v${version}";
    sha256 = "sha256-6CTn8o5geWSesXO7vTrrV/2EOQ3f+nPQ2M5cem13ZSY=";
  };

  # We do not add any propagatedNativeBuildInputs because we do not want the
  # executables idris2 produces to depend on the nix-store. As such, it is left
  # to the user to guarantee chez (or any other codgen dependency) is available
  # in the path during compilation of programs with idris2.
  strictDeps = true;
  nativeBuildInputs = [ makeWrapper clang chez ]
    ++ lib.optional stdenv.isDarwin [ zsh ];
  buildInputs = [ gmp ];

  prePatch = ''
    patchShebangs --build tests
  '';

  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optional stdenv.isDarwin "OS=";

  # The name of the main executable of pkgs.chez is `scheme`
  buildFlags = [ "bootstrap" "SCHEME=scheme" ];

  checkTarget = "test";

  # TODO: Move this into its own derivation, such that this can be changed
  #       without having to recompile idris2 every time.
  postInstall = let
    includedLibs = [ "base" "contrib" "network" "prelude" ];
    name = "${pname}-${version}";
    packagePaths =
      builtins.map (l: "$out/${name}/${l}-${version}") includedLibs;
    additionalIdris2Paths = builtins.concatStringsSep ":" packagePaths;
  in ''
    # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
    rm $out/bin/idris2
    # Move actual idris2 binary
    mv $out/bin/idris2_app/idris2.so $out/bin/idris2

    # After moving the binary, there is nothing left in idris2_app that isn't
    # either contained in lib/ or is useless to us.
    rm $out/bin/idris2_app/*
    rmdir $out/bin/idris2_app

    # idris2 needs to find scheme at runtime to compile
    # idris2 installs packages with --install into the path given by PREFIX.
    # Since PREFIX is in nix-store, it is immutable so --install does not work.
    # If the user redefines PREFIX to be able to install packages, idris2 will
    # not find the libraries and packages since all paths are relative to
    # PREFIX by default.
    # We explicitly make all paths to point to nix-store, such that they are
    # independent of what IDRIS2_PREFIX is. This allows the user to redefine
    # IDRIS2_PREFIX and use --install as expected.
    # TODO: Make support libraries their own derivation such that
    #       overriding LD_LIBRARY_PATH is unnecessary
    # TODO: Maybe set IDRIS2_PREFIX to the users home directory
    wrapProgram "$out/bin/idris2" \
      --set-default CHEZ "${chez}/bin/scheme" \
      --suffix IDRIS2_LIBS ':' "$out/${name}/lib" \
      --suffix IDRIS2_DATA ':' "$out/${name}/support" \
      --suffix IDRIS2_PATH ':' "${additionalIdris2Paths}" \
      --suffix ${if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"} ':' "$out/${name}/lib"
  '';

  meta = {
    description = "A purely functional programming language with first class types";
    homepage = "https://github.com/idris-lang/Idris2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fabianhjr wchresta ];
    inherit (chez.meta) platforms;
  };
}
