{ stdenv, fetchurl, swiProlog, haskellPackages
, glibcLocales, makeWrapper, rlwrap, tk, which }:

let
  fname = "pakcs-1.14.0";

  fsrc = fetchurl {
    url = "http://www.informatik.uni-kiel.de/~pakcs/download/${fname}-src.tar.gz";
    sha256 = "1651ssh4ql79x8asd7kp4yis2n5rhn3lml4s26y03b0cgbfhs78s";
  };

  swiPrologLocked = stdenv.lib.overrideDerivation swiProlog (oldAttrs: rec {
    version = "6.6.6";
    name = "swi-prolog-${version}";
    src = fetchurl {
      url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
      sha256 = "0vcrfskm2hyhv30lxr6v261myb815jc3bgmcn1lgsc9g9qkvp04z";
    };
  });

in
stdenv.mkDerivation rec {

  name = fname;

  curryBase = haskellPackages.callPackage (
    { mkDerivation, base, Cabal, containers, directory, either
    , filepath, mtl, pretty, stdenv, syb, time
    }:
    mkDerivation {
      pname = "curry-base";
      version = "0.4.1";
      src = fsrc;
      libraryHaskellDepends = [
        base containers directory either filepath mtl pretty syb time
      ];
      testHaskellDepends = [ base Cabal filepath mtl ];
      homepage = http://curry-language.org;
      description = "Functions for manipulating Curry programs";
      license = "unknown";

      postUnpack = ''
        mv ${name} ${name}.orig
        ln -s ${name}.orig/frontend/curry-base ${name}
      '';
      doCheck = false;
    }
  ) {};

  curryFront = haskellPackages.callPackage (
    { mkDerivation, base, Cabal, containers, directory
    , filepath, mtl, network-uri, process, stdenv, syb, transformers
    }:
    mkDerivation {
      pname = "curry-frontend";
      version = "0.4.1";
      src = fsrc;
      isLibrary = true;
      isExecutable = true;
      libraryHaskellDepends = [
        base containers curryBase directory filepath mtl network-uri
        process syb transformers
      ];
      executableHaskellDepends = [
        base containers curryBase directory filepath mtl network-uri
        process syb transformers
      ];
      testHaskellDepends = [ base Cabal curryBase filepath ];
      homepage = http://curry-language.org;
      description = "Compile the functional logic language Curry to several intermediate formats";
      license = "unknown";

      postUnpack = ''
        mv ${name} ${name}.orig
        ln -s ${name}.orig/frontend/curry-frontend ${name}
      '';
      doCheck = false;
    }
  ) {};

  src = fsrc;

  buildInputs = [ swiPrologLocked makeWrapper glibcLocales rlwrap tk which ];

  patches = [
    ./adjust-buildsystem.patch
    ./case-insensitive.patch
  ];

  configurePhase = ''
    # Phony HOME.
    mkdir phony-home
    export HOME=$(pwd)/phony-home

    # SWI Prolog
    sed -i 's@SWIPROLOG=@SWIPROLOG='${swiPrologLocked}/bin/swipl'@' scripts/pakcsinitrc.sh
  '';

  buildPhase = ''
    # Some comments in files are in UTF-8, so include the locale needed by GHC runtime.
    export LC_ALL=en_US.UTF-8

    # PAKCS must be build in place due to embedded filesystem references placed by swi.

    # Prepare PAKCSHOME directory.
    mkdir -p $out/pakcs/bin

    # Set up link to cymake, which has been built already.
    ln -s ${curryFront}/bin/cymake $out/pakcs/bin/
    rm -r frontend

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
    for e in "$out/pakcs/tools/emacs/"*.el ; do
      cp $e $out/share/emacs/site-lisp/curry-pakcs/ ;
    done

    # Wrap for rlwrap and tk support.
    wrapProgram $out/pakcs/bin/pakcs \
      --prefix PATH ":" "${rlwrap}/bin" \
      --prefix PATH ":" "${tk}/bin" \
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
    platforms = platforms.unix;
  };
}
