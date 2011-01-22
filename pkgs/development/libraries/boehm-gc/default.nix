{ stdenv, fetchurl, cvsVersion ? true, fetchcvs ? null
, autoconf ? null, automake ? null, libtool ? null }:

let
  cvs = cvsVersion;
  version = if !cvs then "7.1" else "7.2pre20110122";
in
stdenv.mkDerivation ({
  name = "boehm-gc-${version}";

  src =
    if version == "7.1"
    then fetchurl {
      url = "http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-${version}.tar.gz";
      sha256 = "0c5zrsdw0rsli06lahcqwwz0prgah340fhfg7ggfgvz3iw1gdkp3";
      /* else if version == "7.2alpha4" then
               "1ya9hr1wbx0hrx29q5zy2k51ml71k9mhqzqs7f505qr9s6jsfh0b" */
    }

    /* Use the CVS version for now since it contains many, many fixes
       compared to 7.1 and even 7.2alpha4 (e.g., interception of
       `pthread_exit', dated 2010-08-14, which fixes possible deadlocks
       on GNU/Linux.) */
    else fetchcvs {
      cvsRoot = ":pserver:anonymous@bdwgc.cvs.sourceforge.net:/cvsroot/bdwgc";
      module = "bdwgc";
      date = "20110121";
      sha256 = "00f7aed82fa02211db93692c24b74e15010aff545f97691c5e362432a7ae283a";
    };

  patches = stdenv.lib.optional (stdenv.system == "i686-cygwin")
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

(if cvs
 then {
   buildInputs = [ autoconf automake libtool ];
   preConfigure = "autoreconf -vfi";
 }
 else { })

//

(if stdenv.system == "x86_64-darwin"
 # Fix "#error ucontext routines are deprecated, and require _XOPEN_SOURCE to be defined".
 then { configureFlags = "CPPFLAGS=-D_XOPEN_SOURCE"; }
 else {}))
