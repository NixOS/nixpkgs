{ stdenv, fetchurl }:

stdenv.mkDerivation (rec {
  name = "boehm-gc-7.2pre20110122";

  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.tar.bz2";
    sha256 = "06nf60flq6344pgic3bz83jh6pvj4k42apm3x4xwxc4d2is457ly";
  };

  doCheck = true;

  configureFlags = stdenv.lib.optionalString (stdenv.system == "x86_64-darwin") "CPPFLAGS=-D_XOPEN_SOURCE";

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

# Don't run the native `strip' when cross-compiling.
(if (stdenv ? cross)
 then { dontStrip = true; }
 else { }))
