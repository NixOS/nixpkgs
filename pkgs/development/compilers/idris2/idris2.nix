# Almost 1:1 copy of idris2's nix/package.nix. Some work done in their flake.nix
# we do here instead.
{
  stdenv,
  lib,
  chez,
  chez-racket,
  clang,
  gmp,
  fetchFromGitHub,
  makeWrapper,
  gambit,
  nodejs,
  zsh,
  callPackage,
}:

# NOTICE: An `idris2WithPackages` is available at: https://github.com/claymager/idris2-pkgs

let
  platformChez =
    if (stdenv.system == "x86_64-linux") || (lib.versionAtLeast chez.version "10.0.0") then
      chez
    else
      chez-racket;
in
stdenv.mkDerivation rec {
  pname = "idris2";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "idris-lang";
    repo = "Idris2";
    rev = "v${version}";
    sha256 = "sha256-VwveX3fZfrxEsytpbOc5Tm6rySpLFhTt5132J6rmrmM=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    makeWrapper
    clang
    platformChez
  ] ++ lib.optionals stdenv.isDarwin [ zsh ];
  buildInputs = [
    platformChez
    gmp
  ];

  prePatch = ''
    patchShebangs --build tests
  '';

  makeFlags = [ "PREFIX=$(out)" ] ++ lib.optional stdenv.isDarwin "OS=";

  # The name of the main executable of pkgs.chez is `scheme`
  buildFlags = [
    "bootstrap"
    "SCHEME=scheme"
  ];

  checkTarget = "test";
  nativeCheckInputs = [
    gambit
    nodejs
  ]; # racket ];
  checkFlags = [ "INTERACTIVE=" ];

  # TODO: Move this into its own derivation, such that this can be changed
  #       without having to recompile idris2 every time.
  postInstall =
    let
      name = "${pname}-${version}";
      globalLibraries = [
        "\\$HOME/.nix-profile/lib/${name}"
        "/run/current-system/sw/lib/${name}"
        "$out/${name}"
      ];
      globalLibrariesPath = builtins.concatStringsSep ":" globalLibraries;
    in
    ''
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
        --set-default CHEZ "${platformChez}/bin/scheme" \
        --run 'export IDRIS2_PREFIX=''${IDRIS2_PREFIX-"$HOME/.idris2"}' \
        --suffix IDRIS2_LIBS ':' "$out/${name}/lib" \
        --suffix IDRIS2_DATA ':' "$out/${name}/support" \
        --suffix IDRIS2_PACKAGE_PATH ':' "${globalLibrariesPath}" \
        --suffix DYLD_LIBRARY_PATH ':' "$out/${name}/lib" \
        --suffix LD_LIBRARY_PATH ':' "$out/${name}/lib"
    '';

  # Run package tests
  passthru.tests = callPackage ./tests.nix { inherit pname; };

  meta = {
    description = "Purely functional programming language with first class types";
    mainProgram = "idris2";
    homepage = "https://github.com/idris-lang/Idris2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fabianhjr
      wchresta
      mattpolzin
    ];
    inherit (chez.meta) platforms;
  };
}
