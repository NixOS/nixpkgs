{stdenv, fetchurl, g77, readline, ncurses, perl, flex,
 bison, autoconf, automake, sourceByName, getConfig, lib, atlas, gperf, python, glibc, gnuplot, texinfo, texLive, qhull, libX11}:

assert readline != null && ncurses != null && flex != null;
assert g77.langF77;

let commonBuildInputs = [g77 readline ncurses perl glibc qhull libX11 texinfo]; in

stdenv.mkDerivation ({
  NIX_LDFLAGS = "-lpthread";
  configureFlags = "--enable-readline --enable-dl --disable-static --enable-shared";
  meta = { 
      description = "High-level interactive language for numerical computations";
      homepage = http://www.octave.org;
      license = "GPL-3";
    };
} // (
  if (getConfig ["octave" "devVersion"] false) then {
    name = "octave-hg"; # developement version mercurial repo
    src =  sourceByName "octave";
    # HOME is set to $TMP because octave needs to access ${HOME}/.octave_hist while running targets
    # in doc/interpreter.. Maybe this can be done better. This hack is fastest :)
    preConfigure = ''
        # glob is contained in glibc! Don't know why autotools want to use -lglob
        sed -i 's/-lglob//' configure.in
        ./autogen.sh
        export HOME=$TMP
        '';
    buildInputs = commonBuildInputs ++ [ flex bison autoconf automake gperf gnuplot texLive ]
                  ++ lib.optionals (getConfig ["octave" "atlas"] true) [ python atlas ];
    # it does build, but documentation doesn't.. So just remove that directory
    # from the buildfile
    buildPhase = ''
      sed -i octMakefile \
        -e 's/^\(INSTALL_SUBDIRS = .*\)doc \(.*\)$/\1 \2/' \
        -e 's/^\(SUBDIRS = .*\)doc \(.*\)$/\1 \2/' \
        -e 's/\$(MAKE) -C doc/#/'
      make
    '';
  } else {
    name = "octave-3.1.55";
    src =  fetchurl {
      url = ftp://ftp.octave.org/pub/octave/bleeding-edge/octave-3.1.55.tar.bz2;
      sha256 = "1lm4v85kdic4n5yxwzrdb0v6dc6nw06ljgx1q8hfkmi146kpg7s6";
    };
    buildInputs = commonBuildInputs ++ [ flex bison autoconf automake python ]
                  ++ lib.optionals (getConfig ["octave" "atlas"] true) [ python atlas ];
  }
))
