{stdenv, fetchurl}:

let version = "7.1"; in
stdenv.mkDerivation ({
  name = "boehm-gc-${version}";

  src = fetchurl {
    url = "http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-${version}.tar.gz";
    sha256 = "0c5zrsdw0rsli06lahcqwwz0prgah340fhfg7ggfgvz3iw1gdkp3";
  };

  patches =
    stdenv.lib.optional (stdenv.system == "i686-cygwin")
                        ./cygwin-pthread-dl.patch;

  doCheck = true;

  meta = {
    description = "The Boehm-Demers-Weiser conservative garbage collector for C and C++";

    longDescription = ''
      The Boehm-Demers-Weiser conservative garbage collector can be used as a
      garbage collecting replacement for C malloc or C++ new.  It allows you
      to allocate memory basically as you normally would, without explicitly
      deallocating memory that is no longer useful.  The collector
      automatically recycles memory when it determines that it can no longer
      be otherwise accessed.

      The collector is also used by a number of programming language
      implementations that either use C as intermediate code, want to
      facilitate easier interoperation with C libraries, or just prefer the
      simple collector interface.

      Alternatively, the garbage collector may be used as a leak detector for
      C or C++ programs, though that is not its primary goal.
    '';

    homepage = http://www.hpl.hp.com/personal/Hans_Boehm/gc/;

    # non-copyleft, X11-style license
    license = "http://www.hpl.hp.com/personal/Hans_Boehm/gc/license.txt";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}

//

(if stdenv.system == "x86_64-darwin"
 # Fix "#error ucontext routines are deprecated, and require _XOPEN_SOURCE to be defined".
 then { configureFlags = "CPPFLAGS=-D_XOPEN_SOURCE"; }
 else {}))
