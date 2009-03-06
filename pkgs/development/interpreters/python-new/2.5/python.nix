args: with args;
let inherit (lib) optional prepareDerivationArgs concatStringsSep fix;  in

composableDerivation {
  mkDerivation = attr : stdenv.mkDerivation ( attr // {
      C_INCLUDE_PATH = concatStringsSep ":" (map (p: "${p}/include") attr.buildInputs);
      LIBRARY_PATH = concatStringsSep ":" (map (p: "${p}/lib") attr.buildInputs);
    });
  } {

    postPhases = ["runCheck"];

    mergeAttrBy = { pyCheck = x : y : "${x}\n${y}"; };

    # should be last because it sources setup-hook of this package itself
    runCheck = ''
      PATH=$out/bin:$PATH; . $out/nix-support/setup-hook;
      echo -e "import sys\n$pyCheck\nprint \"import pyCheck ok\"" | python
    '';

    inherit (args) name;

    # everything can be overriden by composedArgsAndFun additional args 
    # assuming that if a module can be loaded that it does also work..
    flags = {
      zlib = { buildInputs = [ zlib ]; pyCheck = "import zlib"; };
      gdbm = { buildInputs = [ gdbm ]; pyCheck = "import gdbm"; };
      sqlite = { buildInputs = [ sqlite ]; pyCheck = "import sqlite3"; };
      db4 = { buildInputs = [ db4 ]; }; # TODO add pyCheck
      readline = { buildInputs = [ readline ]; }; # doesn't work yet (?)
      openssl = { buildInputs = [ openssl ]; pyCheck ="import socket\nsocket.ssl"; };
    };

    src = fetchurl {
      url = http://www.python.org/ftp/python/2.5.2/Python-2.5.2.tar.bz2;
      sha256 = "0gh8bvs56vdv8qmlfmiwyczjpldj0y3zbzd0zyhyjfd0c8m0xy7j";
    };

    configureFlags = ["--enable-shared" "--with-wctype-functions"];

    buildInputs =
      optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc ++
      [bzip2 ncurses];

    patches = [
      # Look in C_INCLUDE_PATH and LIBRARY_PATH for stuff.
      ./search-path.patch


      # make python know about libraries reading .pth files
      # http://docs.python.org/library/site.html#module-site
      # TODO: think about security (see the other code contained in site.py)
      ./nix-find-sites-2.5.patch
    ];

    preConfigure = ''
      # Purity.
      for i in /usr /sw /opt /pkg; do 
        substituteInPlace ./setup.py --replace $i /no-such-path
      done
      export NIX_LDFLAGS="$NIX_LDFLAGS -lncurses"
    '';
    
    postInstall = "
      rm -rf $out/lib/python2.5/test
    ";

  }
