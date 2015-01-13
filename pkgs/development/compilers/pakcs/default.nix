{ stdenv, fetchurl, cabal, swiProlog, either, mtl, syb
, glibcLocales, makeWrapper, rlwrap, tk, which }:

let
  fname = "pakcs-1.11.4";

  fsrc = fetchurl {
    url = "http://www.informatik.uni-kiel.de/~pakcs/download/${fname}-src.tar.gz";
    sha256 = "1xsn8h58pi1jp8wr4abyrqdps840j8limyv5i812z49npf91fy5c";
  };

in
stdenv.mkDerivation rec {

  name = fname;

  curryBase = cabal.mkDerivation(self: {
    pname = "curryBase";
    version = "local";
    src = fsrc;
    sourceRoot = "${name}/frontend/curry-base";
    isLibrary = true;
    buildDepends = [ mtl syb ];
  });

  curryFront = cabal.mkDerivation(self: {
    pname = "curryFront";
    version = "local";
    src = fsrc;
    sourceRoot = "${name}/frontend/curry-frontend";
    isLibrary = true;
    isExecutable = true;
    buildDepends = [ either mtl syb curryBase ];
  });

  src = fsrc;

  buildInputs = [ swiProlog makeWrapper glibcLocales rlwrap tk which ];

  patches = [ ./adjust-buildsystem.patch ];

  configurePhase = ''
    # Phony HOME.
    mkdir phony-home
    export HOME=$(pwd)/phony-home

    # SWI Prolog
    sed -i 's@SWIPROLOG=@SWIPROLOG='${swiProlog}/bin/swipl'@' pakcsinitrc
  '';

  buildPhase = ''
    # Some comments in files are in UTF-8, so include the locale needed by GHC runtime.
    export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive
    export LC_ALL=en_US.UTF-8

    # PAKCS must be build in place due to embedded filesystem references placed by swi.

    # Prepare PAKCSHOME directory.
    mkdir -p $out/pakcs/bin

    # Set up link to cymake, which has been built already.
    ln -s ${curryFront}/bin/cymake $out/pakcs/bin/

    # Prevent embedding the derivation build directory as temp.
    export TEMP=/tmp

    # Copy to in place build location and run the build.
    cp -r * $out/pakcs
    (cd $out/pakcs ; make)
  '';

  installPhase = ''
    # Install bin.
    mkdir -p $out/bin
    for b in $(ls $out/pakcs/bin) ; do
      ln -s $out/pakcs/bin/$b $out/bin/ ;
    done

    # Place emacs lisp files in expected locations.
    mkdir -p $out/share/emacs/site-lisp/curry-pakcs
    for e in "$out/tools/emacs/"*.el ; do
      cp $e $out/share/emacs/site-lisp/curry-pakcs/ ;
    done

    # Wrap for rlwrap and tk support.
    wrapProgram $out/pakcs/bin/pakcs \
      --prefix PATH ":" "${rlwrap}/bin" \
      --prefix PATH ":" "${tk}/bin" \
  '';

  meta = {
    homepage = "http://www.informatik.uni-kiel.de/~pakcs/";
    description = "An implementation of the multi-paradigm declarative language Curry";
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
    hydraPlatforms = stdenv.lib.platforms.none;
  };
}
