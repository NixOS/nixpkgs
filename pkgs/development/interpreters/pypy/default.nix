{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, pythonFull, expat, tcl, tk, x11, libX11
, makeWrapper, callPackage, self }:

assert zlibSupport -> zlib != null;

let

  majorVersion = "2.6";
  version = "${majorVersion}.0";
  libPrefix = "pypy${majorVersion}";

  pypy = stdenv.mkDerivation rec {
    name = "pypy-${version}";
    pythonVersion = "2.7";

    inherit majorVersion version;

    src = fetchurl {
      url = "https://bitbucket.org/pypy/pypy/get/release-${version}.tar.bz2";
      sha256 = "0xympj874cnjpxj68xm5gllq2f8bbvz8hr0md8mh1yd6fgzzxibh";
    };

    buildInputs = [ bzip2 openssl pkgconfig pythonFull libffi ncurses expat sqlite tk tcl x11 libX11 makeWrapper ]
      ++ stdenv.lib.optional (stdenv ? cc && stdenv.cc.libc != null) stdenv.cc.libc
      ++ stdenv.lib.optional zlibSupport zlib;

    C_INCLUDE_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/include") buildInputs);
    LIBRARY_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/lib") buildInputs);
    LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p}/lib")
      (stdenv.lib.filter (x : x.outPath != stdenv.cc.libc.outPath or "") buildInputs));

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
      substituteInPlace lib_pypy/_tkinter/tklib_build.py \
        --replace "'/usr/include/tcl'" "'${tk}/include', '${tcl}/include'" \
        --replace "linklibs = ['tcl' + _ver, 'tk' + _ver]" "linklibs=['${tcl.libPrefix}', '${tk.libPrefix}']" \
        --replace "libdirs = []" "libdirs = ['${tk}/lib', '${tcl}/lib']"

      sed -i "s@libraries=\['sqlite3'\]\$@libraries=['sqlite3'], include_dirs=['${sqlite}/include'], library_dirs=['${sqlite}/lib']@" lib_pypy/_sqlite3_build.py
    '';

    setupHook = ./setup-hook.sh;

    postBuild = ''
      cd ./lib_pypy
        ../pypy-c ./_audioop_build.py
        ../pypy-c ./_curses_build.py
        ../pypy-c ./_pwdgrp_build.py
        ../pypy-c ./_sqlite3_build.py
        ../pypy-c ./_syslog_build.py
        ../pypy-c ./_tkinter/tklib_build.py
      cd ..
    '';

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
       # disable test_cpickle because timeouts
       # disable test_ssl because no shared cipher' not found in '[Errno 1] error:14077410:SSL routines:SSL23_GET_SERVER_HELLO:sslv3 alert handshake failure
      ./pypy-c ./pypy/test_all.py --pypy=./pypy-c -k 'not (test_ssl or test_cpickle or test_sqlite or test_urllib2net or test_urllibnet or test_socket or test_os or test_shutil or test_mhlib or test_multiprocessing or test_zipfile64)' lib-python
    '';

    installPhase = ''
       mkdir -p $out/{bin,include,lib,pypy-c}

       cp -R {include,lib_pypy,lib-python,pypy-c} $out/pypy-c
       cp libpypy-c.so $out/lib/
       ln -s $out/pypy-c/pypy-c $out/bin/pypy
       chmod +x $out/bin/pypy

       # other packages expect to find stuff according to libPrefix
       ln -s $out/pypy-c/include $out/include/${libPrefix}
       ln -s $out/pypy-c/lib-python/${pythonVersion} $out/lib/${libPrefix}

       # We must wrap the original, not the symlink.
       # PyPy uses argv[0] to find its standard library, and while it knows
       # how to follow symlinks, it doesn't know about wrappers. So, it
       # will think the wrapper is the original. As long as the wrapper has
       # the same path as the original, this is OK.
       wrapProgram "$out/pypy-c/pypy-c" \
         --set LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:$out/lib" \
         --set LIBRARY_PATH "${LIBRARY_PATH}:$out/lib"

       # verify cffi modules
       $out/bin/pypy -c "import Tkinter;import sqlite3;import curses"
    '';

    passthru = rec {
      inherit zlibSupport libPrefix;
      executable = "pypy";
      isPypy = true;
      buildEnv = callPackage ../python/wrapper.nix { python = self; };
      interpreter = "${self}/bin/${executable}";
      sitePackages = "lib/${libPrefix}/site-packages";
    };

    enableParallelBuilding = true;  # almost no parallelization without STM

    meta = with stdenv.lib; {
      homepage = http://pypy.org/;
      description = "Fast, compliant alternative implementation of the Python language (2.7.8)";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ iElectric ];
    };
  };

in pypy
