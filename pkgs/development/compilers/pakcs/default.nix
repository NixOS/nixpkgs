{ stdenv, fetchurl, cabal, swiProlog, either, mtl, syb
, glibcLocales, makeWrapper, rlwrap, tk }:

let
  fname = "pakcs-1.11.3";

  fsrc = fetchurl {
    url = "http://www.informatik.uni-kiel.de/~pakcs/download/${fname}-src.tar.gz";
    sha256 = "0f4rhaqss9vfinpdjchxq75g343hz322cv0admjnl4g5g568wk3x";
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

  buildInputs = [ swiProlog makeWrapper glibcLocales rlwrap tk ];

  patches = [ ./adjust-buildsystem.patch ];

  configurePhase = ''
    # Phony HOME.
    mkdir phony-home
    export HOME=$(pwd)/phony-home

    # SWI Prolog
    sed -i 's@SWIPROLOG=@SWIPROLOG='${swiProlog}/bin/swipl'@' pakcsinitrc
  '';

  preBuild = ''
    # Some comments in files are in UTF-8, so include the locale needed by GHC runtime.
    export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive
    export LC_ALL=en_US.UTF-8

    # Set up link to cymake, which has been built already.
    mkdir -p bin/.local
    ln -s ${curryFront}/bin/cymake bin/.local/
  '';

  installPhase = ''
    # Prepare PAKCSHOME directory.
    mkdir -p $out/pakcs
    for d in bin curry2prolog currytools lib tools cpns include www examples docs ; do
      cp -r $d $out/pakcs ;
    done
    cp pakcsrc.default $out/pakcs
    cp pakcsinitrc $out/pakcs

    # Fixing PAKCSHOME and related paths.
    sed -i 's@PAKCSHOME=/tmp/.*@PAKCSHOME='$out/pakcs'@' $out/pakcs/bin/{pakcs,makecurrycgi,parsecurry,.makesavedstate}

    # The Prolog sources must be rebuilt in their final directory,
    # to switch the embedded references to the tmp build directory.
    export TEMP=/tmp
    (cd $out/pakcs/curry2prolog/ ; rm c2p.state ; make)
    cp Makefile $out/pakcs
    (cd $out/pakcs ; make tools)
    (cd $out/pakcs/cpns ; make)
    (cd $out/pakcs/www ; make)

    # Install bin.
    mkdir -p $out/bin
    for b in makecurrycgi .makesavedstate pakcs parsecurry cleancurry \
             addtypes cass currybrowse currycreatemake currydoc currytest \
             dataToXml erd2curry ; do
      ln -s $out/pakcs/bin/$b $out/bin/ ;
    done

    # Place emacs lisp files in expected locations.
    mkdir -p $out/share/emacs/site-lisp/curry-pakcs
    for e in "tools/emacs/"*.el ; do
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
    broken = true;
  };
}
