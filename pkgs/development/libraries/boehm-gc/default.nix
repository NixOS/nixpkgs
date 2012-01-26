{ stdenv, fetchurl }:

stdenv.mkDerivation (rec {
  name = "boehm-gc-7.2alpha6";

  src = fetchurl {
    url = "http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-7.2alpha6.tar.gz";
    sha256 = "05jwadjbrv8pr7z9cb4miskicxqpxm0pca4h2rg5cgbpajr2bx7b";
  };

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

# Don't run the native `strip' when cross-compiling.
(if (stdenv ? cross)
 then { dontStrip = true; }
 else { }))
