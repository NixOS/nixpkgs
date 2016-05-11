{ stdenv, fetchurl, zlib ? null, zlibSupport ? true, bzip2, pkgconfig, libffi
, sqlite, openssl, ncurses, pythonFull, expat, tcl, tk, xlibsWrapper, libX11
, makeWrapper, callPackage, self, gdbm, db }:

assert zlibSupport -> zlib != null;

let

  majorVersion = "5.1.1";
  version = "${majorVersion}";
  libPrefix = "pypy${majorVersion}";

  pypy = stdenv.mkDerivation rec {
    name = "pypy-${version}";
    pythonVersion = "2.7";

    inherit majorVersion version;

    src = fetchurl {
      url = "https://bitbucket.org/pypy/pypy/get/release-${version}.tar.bz2";
      sha256 = "1dmckvffanmh0b50pq34shnw05r55gjxn43kgvnkz5kkvvsbxdg1";
    };

    buildInputs = [ bzip2 openssl pkgconfig pythonFull libffi ncurses expat sqlite tk tcl xlibsWrapper libX11 makeWrapper gdbm db ]
      ++ stdenv.lib.optional (stdenv ? cc && stdenv.cc.libc != null) stdenv.cc.libc
      ++ stdenv.lib.optional zlibSupport zlib;

    C_INCLUDE_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p.dev or p}/include") buildInputs);
    LIBRARY_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p.lib or p.out or p}/lib") buildInputs);
    LD_LIBRARY_PATH = stdenv.lib.concatStringsSep ":" (map (p: "${p.lib or p.out or p}/lib")
      (stdenv.lib.filter (x : x.outPath != stdenv.cc.libc.outPath or "") buildInputs));

    preConfigure = ''
      # hint pypy to find nix ncurses
      substituteInPlace pypy/module/_minimal_curses/fficurses.py \
        --replace "/usr/include/ncurses/curses.h" "${ncurses.dev}/include/curses.h" \
        --replace "ncurses/curses.h" "${ncurses.dev}/include/curses.h" \
        --replace "ncurses/term.h" "${ncurses.dev}/include/term.h" \
        --replace "libraries=['curses']" "libraries=['ncurses']"

      # tkinter hints
      substituteInPlace lib_pypy/_tkinter/tklib_build.py \
        --replace "'/usr/include/tcl'" "'${tk}/include', '${tcl}/include'" \
        --replace "linklibs = ['tcl' + _ver, 'tk' + _ver]" "linklibs=['${tcl.libPrefix}', '${tk.libPrefix}']" \
        --replace "libdirs = []" "libdirs = ['${tk}/lib', '${tcl}/lib']"

      sed -i "s@libraries=\['sqlite3'\]\$@libraries=['sqlite3'], include_dirs=['${sqlite.dev}/include'], library_dirs=['${sqlite.out}/lib']@" lib_pypy/_sqlite3_build.py
    '';

    buildPhase = ''
      ${pythonFull.interpreter} rpython/bin/rpython --make-jobs="$NIX_BUILD_CORES" -Ojit --batch pypy/goal/targetpypystandalone.py --withmod-_minimal_curses --withmod-unicodedata --withmod-thread --withmod-bz2 --withmod-_multiprocessing
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
       export TERMINFO="${ncurses.out}/share/terminfo/";
       export TERM="xterm";
       export HOME="$TMPDIR";
       # disable shutils because it assumes gid 0 exists
       # disable socket because it has two actual network tests that fail
       # disable test_urllib2net, test_urllib2_localnet, and test_urllibnet because they require networking (example.com)
       # disable test_ssl because no shared cipher' not found in '[Errno 1] error:14077410:SSL routines:SSL23_GET_SERVER_HELLO:sslv3 alert handshake failure
       # disable test_zipfile64 because it causes ENOSPACE
       # disable test_epoll because of invalid arg, should be fixed in as of version 5.1.2
      ./pypy-c ./pypy/test_all.py --pypy=./pypy-c -k 'not ( test_ssl or test_urllib2net or test_urllibnet or test_urllib2_localnet or test_socket or test_shutil or test_zipfile64 or test_epoll )' lib-python
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
      sitePackages = "site-packages";
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
