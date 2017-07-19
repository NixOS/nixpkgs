{ lib, stdenv, fetchurl, pkgconfig, libatomic_ops, enableLargeConfig ? false
, buildPlatform, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "boehm-gc-7.6.0";

  src = fetchurl {
    url = http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz;
    sha256 = "143x7g0d0k6250ai6m2x3l4y352mzizi4wbgrmahxscv2aqjhjm1";
  };

  buildInputs = [ libatomic_ops ];
  nativeBuildInputs = [ pkgconfig ];

  outputs = [ "out" "dev" "doc" ];
  separateDebugInfo = stdenv.isLinux;

  configureFlags =
    [ "--enable-cplusplus" ]
    ++ lib.optional enableLargeConfig "--enable-large-config";

  doCheck = true;

  # Don't run the native `strip' when cross-compiling.
  dontStrip = hostPlatform != buildPlatform;

  postInstall =
    ''
      mkdir -p $out/share/doc
      mv $out/share/gc $out/share/doc/gc
    '';

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
