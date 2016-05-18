{ stdenv, fetchurl, pkgconfig, gfortran, texinfo

# Select SIMD alignment width (in bytes) for vectorization.
, simdWidth ? 1

# Pad arrays to simdWidth by default?
# Note: Only useful if simdWidth > 1
, enablePadding ? false

# Activate serialization through Boost.Serialize?
, enableSerialization ? true, boost ? null

# Activate test-suite?
# WARNING: Some of the tests require up to 1700MB of memory to compile.
, doCheck ? true

}:

assert enableSerialization -> boost != null;

let
  inherit (stdenv.lib) optional optionals optionalString;
in

stdenv.mkDerivation rec {
  name = "blitz++-0.10";
  src = fetchurl {
    url = mirror://sourceforge/blitz/blitz-0.10.tar.gz;
    sha256 = "153g9sncir6ip9l7ssl6bhc4qzh0qr3lx2d15qm68hqxj7kg0kl0";
  };

  patches = [ ./blitz-gcc47.patch ./blitz-testsuite-stencil-et.patch ];

  buildInputs = [ pkgconfig gfortran texinfo ]
    ++ optional (boost != null) [ boost.out ];

  configureFlags =
    [ "--enable-shared"
      "--disable-static"
      "--enable-fortran"
      "--enable-optimize"
      "--with-pic=yes"
      "--enable-html-docs"
      "--disable-doxygen"
      "--disable-dot"
      "--disable-latex-docs"
      "--enable-simd-width=${toString simdWidth}"
    ]
    ++ optional enablePadding "--enable-array-length-padding"
    ++ optional enableSerialization "--enable-serialization"
    ++ optionals (boost != null) [ "--with-boost=${boost.dev}"
                                   "--with-boost-libdir=${boost.out}/lib" ]
    ++ optional stdenv.is64bit "--enable-64bit"
    ;

  enableParallelBuilding = true;

  buildFlags = "lib info pdf html";
  installTargets = [ "install" "install-info" "install-pdf" "install-html" ];

  inherit doCheck;
  checkTarget = "check-testsuite check-examples";

  meta = {
    description = "Fast multi-dimensional array library for C++";
    homepage = http://sourceforge.net/projects/blitz/;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.aherrmann ];

    longDescription = ''
      Blitz++ is a C++ class library for scientific computing which provides
      performance on par with Fortran 77/90. It uses template techniques to
      achieve high performance. Blitz++ provides dense arrays and vectors,
      random number generators, and small vectors (useful for representing
      multicomponent or vector fields).
    '';
  };
}
