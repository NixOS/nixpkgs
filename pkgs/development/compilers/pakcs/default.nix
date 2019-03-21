{ stdenv, fetchurl, makeWrapper
, haskellPackages, haskell
, which, swiProlog, rlwrap, tk
, curl, git, unzip, gnutar, coreutils, sqlite }:

let
  name = "pakcs-2.0.2";

  # Don't switch to development release without a reason, because its
  # source updates without version bump. Prefer current release instead.
  src = fetchurl {
    url = "https://www.informatik.uni-kiel.de/~pakcs/download/${name}-src.tar.gz";
    sha256 = "1hm80gvpsifbsfi13i0iiv7f2b72ymw98bbrm6a8hjsbnfw55jvg";
  };

  curry-frontend = (haskellPackages.override {
    overrides = self: super: {
      curry-base = haskell.lib.overrideCabal (super.callPackage ./curry-base.nix {}) (drv: {
        inherit src;
        postUnpack = "sourceRoot+=/frontend/curry-base";
      });
      curry-frontend = haskell.lib.overrideCabal (super.callPackage ./curry-frontend.nix {}) (drv: {
        inherit src;
        postUnpack = "sourceRoot+=/frontend/curry-frontend";
      });
    };
  }).curry-frontend;
in stdenv.mkDerivation {
  inherit name src;

  buildInputs = [ swiProlog ];
  nativeBuildInputs = [ which makeWrapper ];

  makeFlags = [
    "CURRYFRONTEND=${curry-frontend}/bin/curry-frontend"
    "DISTPKGINSTALL=yes"
    # Not needed, just to make script pass
    "CURRYTOOLSDIR=0"
    "CURRYLIBSDIR=0"
  ];

  preConfigure = ''
    # Since we can't expand $out in `makeFlags`
    #makeFlags="$makeFlags PAKCSINSTALLDIR=$out/pakcs"

    substituteInPlace currytools/cpm/src/CPM/Repository.curry \
      --replace "/bin/rm" "rm"
  '';

  # cypm new: EXISTENCE ERROR: source_sink
  # "/tmp/nix-build-pakcs-2.0.2.drv-0/pakcs-2.0.2/currytools/cpm/templates/LICENSE"
  # does not exist
  buildPhase = ''
    mkdir -p $out/pakcs
    cp -r * $out/pakcs
    (cd $out/pakcs ; make -j$NIX_BUILD_CORES $makeFlags)
  '';

  installPhase = ''
    ln -s $out/pakcs/bin $out

    mkdir -p $out/share/emacs/site-lisp
    ln -s $out/pakcs/tools/emacs $out/share/emacs/site-lisp/curry-pakcs

    wrapProgram $out/pakcs/bin/pakcs \
      --prefix PATH ":" "${rlwrap}/bin" \
      --prefix PATH ":" "${tk}/bin"

    # List of dependencies from currytools/cpm/src/CPM/Main.curry
    wrapProgram $out/pakcs/bin/cypm \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ curl git unzip gnutar coreutils sqlite ]}"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.informatik.uni-kiel.de/~pakcs/;
    description = "An implementation of the multi-paradigm declarative language Curry";
    license = licenses.bsd3;

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

    maintainers = with maintainers; [ kkallio gnidorah ];
    platforms = platforms.linux;
  };
}
