{ lib, stdenv, fetchurl, enableLargeConfig ? false }:

stdenv.mkDerivation rec {
  name = "boehm-gc-7.2f";

  src = fetchurl {
    url = http://www.hboehm.info/gc/gc_source/gc-7.2f.tar.gz;
    sha256 = "119x7p1cqw40mpwj80xfq879l9m1dkc7vbc1f3bz3kvkf8bf6p16";
  };

  patches = if stdenv.isCygwin then [ ./cygwin.patch ] else null;

  configureFlags =
    [ "--enable-cplusplus" ]
    ++ lib.optional enableLargeConfig "--enable-large-config";

  doCheck = true;

  # Don't run the native `strip' when cross-compiling.
  dontStrip = stdenv ? cross;

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

    homepage = http://hboehm.info/gc/;

    # non-copyleft, X11-style license
    license = http://hboehm.info/gc/license.txt;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
