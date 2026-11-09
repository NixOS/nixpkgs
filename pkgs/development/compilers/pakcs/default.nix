{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  makeWrapper,
  haskellPackages,
  haskell,
  which,
  swi-prolog,
  rlwrap,
  tk,
  curl,
  git,
  unzip,
  gnutar,
  coreutils,
  sqlite,
  gettext,
}:

let
  pname = "pakcs";
  version = "3.9.0";

  src = fetchurl {
    url = "https://www.curry-lang.org/pakcs/download/pakcs-${version}-src.tar.gz";
    hash = "sha256-uiWlHJsiy1o4CQOZBa69YJacjhFBap1mSlhxEMtUDKI=";
  };

  curry-frontend =
    (haskellPackages.override {
      overrides = self: super: {
        curry-frontend = lib.pipe (super.callPackage ./curry-frontend.nix { }) [
          haskell.lib.doJailbreak
          (haskell.lib.compose.overrideCabal (drv: {
            inherit src;
            postUnpack = "sourceRoot+=/frontend";
          }))
        ];
      };
    }).curry-frontend;

in
stdenv.mkDerivation {
  inherit pname version src;

  buildInputs = [ swi-prolog ];
  nativeBuildInputs = [
    which
    makeWrapper
    gettext
  ];

  makeFlags = [
    "CURRYFRONTEND=${curry-frontend}/bin/curry-frontend"
    "DISTPKGINSTALL=yes"
    # Not needed, just to make script pass
    "CURRYTOOLSDIR=0"
    "CURRYLIBSDIR=0"
  ];

  preConfigure = ''
    for file in examples/test.sh             \
                currytools/optimize/Makefile \
                testsuite/test.sh            \
                scripts/cleancurry.sh        \
                scripts/compile-all-libs.sh; do
        substituteInPlace $file --replace "/bin/rm" "rm"
    done
  '';

  preBuild = ''
    mkdir -p $out/pakcs
    cp -r * $out/pakcs
    cd $out/pakcs
  '';

  installPhase = ''
    runHook preInstall

    ln -s $out/pakcs/bin $out

    mkdir -p $out/share/emacs/site-lisp
    ln -s $out/pakcs/tools/emacs $out/share/emacs/site-lisp/curry-pakcs

    wrapProgram $out/pakcs/bin/pakcs \
      --prefix PATH ":" "${rlwrap}/bin" \
      --prefix PATH ":" "${tk}/bin"

    # List of dependencies from currytools/cpm/src/CPM/Main.curry
    wrapProgram $out/pakcs/bin/cypm \
      --prefix PATH ":" "${
        lib.makeBinPath [
          curl
          git
          unzip
          gnutar
          coreutils
          sqlite
        ]
      }"

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.curry-lang.org/pakcs";
    description = "Implementation of the multi-paradigm declarative language Curry";
    license = lib.licenses.bsd3;

    longDescription = ''
      PAKCS is an implementation of the multi-paradigm declarative language
      Curry jointly developed by the Portland State University, the Aachen
      University of Technology, and the University of Kiel. Although this is
      not a highly optimized implementation but based on a high-level
      compilation of Curry programs into Prolog programs, it is not a toy
      implementation but has been used for a variety of applications (e.g.,
      graphical programming environments, an object-oriented front-end for
      Curry, partial evaluators, database applications, HTML programming
      with dynamic web pages, prototyping embedded systems).
    '';

    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = lib.platforms.linux;
  };
}
