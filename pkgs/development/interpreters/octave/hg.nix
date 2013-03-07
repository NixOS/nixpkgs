{stdenv, fetchurl, gfortran, readline, ncurses, perl, flex,
 bison, autoconf, automake, sourceFromHead, config, lib, atlas, gperf, python, glibc, gnuplot, texinfo, texLive, qhull, libX11}:

let commonBuildInputs = [gfortran readline ncurses perl glibc qhull libX11 texinfo]; in

stdenv.mkDerivation ({
  NIX_LDFLAGS = "-lpthread";
  configureFlags = "--enable-readline --enable-dl";
  meta = { 
      description = "High-level interactive language for numerical computations";
      homepage = http://www.octave.org;
      license = "GPL-3";
    };
} // (
  if config.octave.devVersion or false then {
    name = "octave-hg"; # developement version mercurial repo
    # REGION AUTO UPDATE:   { name="octave"; type = "hg"; url = "http://www.octave.org/hg/octave"; }
    src = sourceFromHead "octave-03b414516dd8.tar.gz"
                 (fetchurl { url = "http://mawercer.de/~nix/repos/octave-03b414516dd8.tar.gz"; sha256 = "30877f1e2ff1a456e7a76153aabf7c59ce7c7a8b63eda0515b1eead6a4351ce7"; });
    # END
    # HOME is set to $TMP because octave needs to access ${HOME}/.octave_hist while running targets
    # in doc/interpreter.. Maybe this can be done better. This hack is fastest :)
    preConfigure = ''
        # glob is contained in glibc! Don't know why autotools want to use -lglob
        sed -i 's/-lglob//' configure.in
        ./autogen.sh
        export HOME=$TMP
        '';
    buildInputs = commonBuildInputs ++ [ flex bison autoconf automake gperf gnuplot texLive ]
                  ++ lib.optionals (config.octave.atlas or true) [ python atlas ];
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
                  ++ lib.optionals (config.octave.atlas or true) [ python atlas ];
  }
))
