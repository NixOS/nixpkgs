{ stdenv, fetchurl, ghc, swiProlog, syb, mtl, makeWrapper, rlwrap, tk }:

stdenv.mkDerivation {
  name = "pakcs-1.10.0";

  src = fetchurl {
    url = "http://www.informatik.uni-kiel.de/~pakcs/download/pakcs_src.tar.gz";
    sha256 = "6a4a45c9f3d0b61cfec8414943c2a852bec3665a7e2638b039193dd43e9802c4";
  };

  buildInputs = [ ghc swiProlog syb mtl makeWrapper rlwrap tk ];

  prePatch = ''
    # Remove copying pakcsrc into $HOME.
    sed -i '/update-pakcsrc/d' Makefile

    # Remove copying pakcsinitrc into $HOME
    sed -i '68d' configure-pakcs
  '';

  patches = [ ./pakcs-ghc741.patch ];

  preConfigure = ''
    # Path to GHC and SWI Prolog
    sed -i 's@GHC=@GHC=${ghc}/bin/ghc@' bin/.pakcs_variables
    sed -i 's@SWIPROLOG=@SWIPROLOG=${swiProlog}/bin/swipl@' bin/.pakcs_variables
  '';

  postInstall = ''
    cp pakcsrc $out/
    cp update-pakcsrc $out/
    cp -r bin/ $out/
    cp -r cpns/ $out/
    cp -r curry2prolog/ $out/
    cp -r docs/ $out/
    cp -r examples/ $out/
    cp -r include/ $out/
    cp -r lib/ $out/
    cp -r mccparser/ $out/
    cp -r tools/ $out/
    cp -r www/ $out/

    # The Prolog sources must be built in their final directory.
    (cd $out/curry2prolog/ ; make)

    mkdir -p $out/share/emacs/site-lisp/curry-pakcs
    for e in "$out/tools/emacs/"*.el ; do
      ln -s $e $out/share/emacs/site-lisp/curry-pakcs/;
    done

    sed -i 's@which@type -P@' $out/bin/.pakcs_wrapper

    # Get the program name from the environment instead of the calling wrapper (for rlwrap).
    sed -i 's@progname=`basename "$0"`@progname=$PAKCS_PROGNAME@' $out/bin/.pakcs_wrapper

    wrapProgram $out/bin/.pakcs_wrapper \
      --prefix PATH ":" "${rlwrap}/bin" \
      --prefix PATH ":" "${tk}/bin" \
      --run 'export PAKCS_PROGNAME=`basename "$0"`'
  '';

  meta = {
    homepage = "http://www.informatik.uni-kiel.de/~pakcs/";
    description = "an implementation of the multi-paradigm declarative language Curry";
    license = stdenv.lib.licenses.bsd3;

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

    maintainers = [ stdenv.lib.maintainers.kkallio ];
    platforms = stdenv.lib.platforms.linux;
  };
}
