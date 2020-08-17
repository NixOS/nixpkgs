{ stdenv, fetchFromGitHub, makeWrapper
, clang, chez
}:

# Uses scheme to bootstrap the build of idris2
let
  idris2name = "idris2";
  idris2version = "0.2.1";
  includedLibs = [ "base" "contrib" "network" "prelude" ];
  internalVersionString = "${idris2name}-${idris2version}";
in stdenv.mkDerivation rec {
  name = idris2name;
  version = idris2version;

  src = fetchFromGitHub {
    owner = "idris-lang";
    repo = "Idris2";
    rev = "v${version}";
    sha256 = "044slgl2pwvj939kz3z92n6l182plc5fzng1n4z4k6bg11msqq14";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper clang chez ];
  buildInputs = [ chez ];

  prePatch = ''
    patchShebangs --build tests
  '';

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "OS=";

  # The name of the main executable of pkgs.chez is `scheme`
  buildFlags = [ "bootstrap-build" "SCHEME=scheme" ];

  checkTarget = "bootstrap-test";

  # TODO: Move this into its down derivation, such that this can be changes
  #       without having to recompile idris2 every time.
  postInstall = let
    packagePaths = builtins.map (l: "$out/${internalVersionString}/" + l) includedLibs;
    additionalIdris2Paths = builtins.concatStringsSep ":" packagePaths;
  in ''
    # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
    rm $out/bin/idris2
    # Move actual idris2 binary
    mv $out/bin/idris2_app/idris2.so $out/bin/idris2

    # Remove idris2_app contents
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
      --suffix IDRIS2_LIBS ':' "$out/${internalVersionString}/lib" \
      --suffix IDRIS2_DATA ':' "$out/${internalVersionString}/support" \
      --suffix IDRIS2_PATH ':' "${additionalIdris2Paths}" \
      --suffix LD_LIBRARY_PATH ':' "$out/${internalVersionString}/lib"
  '';

  meta = {
    description = "A purely functional programming language with first class types";
    homepage = "https://github.com/idris-lang/Idris2";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ wchresta ];
    inherit (chez.meta) platforms;
  };
}

