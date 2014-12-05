{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, pythonFull, expat, tcl, tk, x11, libX11
, makeWrapper, callPackage, self }:

assert zlibSupport -> zlib != null;

let

  majorVersion = "2.4";
  version = "${majorVersion}.0";
  pythonVersion = "2.7";
  libPrefix = "pypy${majorVersion}";

  pypy = stdenv.mkDerivation rec {
    name = "pypy-${version}";

    inherit majorVersion version;

    src = fetchurl {
      url = "https://bitbucket.org/pypy/pypy/get/release-${version}.tar.bz2";
      sha256 = "1lhk86clnkj305dxa6xr9wjib6ckf6xxl6qj0bq20vqh80nfq3by";
    };

    buildInputs = [ bzip2 openssl pkgconfig pythonFull libffi ncurses expat sqlite tk tcl x11 libX11 makeWrapper ]
      ++ stdenv.lib.optional (stdenv ? gcc && stdenv.gcc.libc != null) stdenv.gcc.libc
      ++ stdenv.lib.optional zlibSupport zlib;

    C_INCLUDE_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/include") buildInputs);
    LIBRARY_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
    LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/lib") 
      (stdenv.lib.filter (x : x.outPath != stdenv.gcc.libc.outPath or "") buildInputs));

    preConfigure = ''
      substituteInPlace Makefile \
        --replace "-Ojit" "-Ojit --batch" \
        --replace "pypy/goal/targetpypystandalone.py" "pypy/goal/targetpypystandalone.py --withmod-_minimal_curses --withmod-unicodedata --withmod-thread --withmod-bz2 --withmod-_multiprocessing"

      # we are using cpython and not pypy to do translation
      substituteInPlace rpython/bin/rpython \
        --replace "/usr/bin/env pypy" "${pythonFull}/bin/python"
      substituteInPlace pypy/goal/targetpypystandalone.py \
        --replace "/usr/bin/env pypy" "${pythonFull}/bin/python"

      # hint pypy to find nix ncurses
      substituteInPlace pypy/module/_minimal_curses/fficurses.py \
        --replace "/usr/include/ncurses/curses.h" "${ncurses}/include/curses.h" \
        --replace "ncurses/curses.h" "${ncurses}/include/curses.h" \
        --replace "ncurses/term.h" "${ncurses}/include/term.h" \
        --replace "libraries=['curses']" "libraries=['ncurses']"

      # tkinter hints
      substituteInPlace lib_pypy/_tkinter/tklib.py \
        --replace "'/usr/include/tcl'" "'${tk}/include', '${tcl}/include'" \
        --replace "linklibs=['tcl', 'tk']" "linklibs=['tcl8.5', 'tk8.5']" \
        --replace "libdirs = []" "libdirs = ['${tk}/lib', '${tcl}/lib']"

      sed -i "s@libraries=\['sqlite3'\]\$@libraries=['sqlite3'], include_dirs=['${sqlite}/include'], library_dirs=['${sqlite}/lib']@" lib_pypy/_sqlite3.py
    '';

    setupHook = ./setup-hook.sh;

    doCheck = true;
    checkPhase = ''
       export TERMINFO="${ncurses}/share/terminfo/";
       export TERM="xterm";
       export HOME="$TMPDIR";
       # disable shutils because it assumes gid 0 exists
       # disable socket because it has two actual network tests that fail
       # disable test_mhlib because it fails for unknown reason
       # disable sqlite3 due to https://bugs.pypy.org/issue1740
       # disable test_multiprocessing due to transient errors
       # disable test_os because test_urandom_failure fails
       # disable test_urllib2net and test_urllibnet because it requires networking (example.com)
       # disable test_zipfile64 because it randomly timeouts
       # disable test_default_ciphers because of error message mismatch
      ./pypy-c ./pypy/test_all.py --pypy=./pypy-c -k 'not (test_sqlite or test_default_ciphers or test_urllib2net or test_urllibnet or test_socket or test_os or test_shutil or test_mhlib or test_multiprocessing or test_zipfile64)' lib-python
    '';

    installPhase = ''
       mkdir -p $out/{bin,include,lib,pypy-c}

       cp -R {include,lib_pypy,lib-python,pypy-c} $out/pypy-c
       ln -s $out/pypy-c/pypy-c $out/bin/pypy
       chmod +x $out/bin/pypy

       # other packages expect to find stuff according to libPrefix
       ln -s $out/pypy-c/include $out/include/${libPrefix}
       ln -s $out/pypy-c/lib-python/${pythonVersion} $out/lib/${libPrefix}

       # verify cffi modules
       $out/bin/pypy -c "import Tkinter;import sqlite3;import curses"

       # make sure pypy finds sqlite3 library
       wrapProgram "$out/bin/pypy" \
         --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}" \
         --set LIBRARY_PATH "${LIBRARY_PATH}"
    '';

    passthru = rec {
      inherit zlibSupport libPrefix;
      executable = "pypy";
      isPypy = true;
      buildEnv = callPackage ../../python/wrapper.nix { python = self; };
      interpreter = "${self}/bin/${executable}";
    };

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = http://pypy.org/;
      description = "Fast, compliant alternative implementation of the Python language (2.7.3)";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ iElectric ];
    };
  };

in pypy
