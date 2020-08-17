{ stdenv, fetchFromGitHub, makeWrapper
, clang, chez
}:

# Uses scheme to bootstrap the build of idris2
let
  includedLibs = [ "base" "contrib" "network" "prelude" ];
  internalVersionString = "idris2-0.2.0";
in stdenv.mkDerivation rec {
  name = "idris2";
  version = "0.2.1";

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
    includedLibPaths = builtins.map (x: "$out/${internalVersionString}/" + x) includedLibs;
    libPath = builtins.concatStringsSep ":" includedLibPaths;
  in ''
    # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
    rm $out/bin/idris2
    # Move actual idris2 binary
    mv $out/bin/idris2_app/idris2.so $out/bin/idris2

    # Remove idris2_app contents
    rm $out/bin/idris2_app/*
    rmdir $out/bin/idris2_app

    # idris2 needs to find scheme at runtime to compile
    # We also fix most Idris 2 paths to point to the out directory
    # such that we can redefine PREFIX to point to the default user
    # directory. That way, we are able to allow for --install
    # TODO: Make support libraries their own derivation such that
    #       overriding LD_LIBRARY_PATH is unnecessary
    # TODO: Maybe set IDRIS2_PREFIX to the users home directory
    wrapProgram "$out/bin/idris2" \
      --set-default CHEZ "${chez}/bin/scheme" \
      --set-default IDRIS2_LIBS "$out/${internalVersionString}/lib" \
      --set-default IDRIS2_DATA "$out/${internalVersionString}/support" \
      --set-default IDRIS2_PATH "${libPath}" \
      --set LD_LIBRARY_PATH "$out/${internalVersionString}/lib"
  '';

  meta = {
    description = "A purely functional programming language with first class types";
    homepage = "https://github.com/idris-lang/Idris2";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ wchresta ];
    inherit (chez.meta) platforms;
  };
}
