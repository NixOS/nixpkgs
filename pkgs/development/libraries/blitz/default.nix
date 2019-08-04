{ stdenv, lib, fetchurl, pkg-config, gfortran, texinfo, python

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
  inherit (lib) optional optionals;
in

stdenv.mkDerivation rec {
  name = "blitz++-1.0.1";
  src = fetchurl {
    url = "https://github.com/blitzpp/blitz/archive/1.0.1.tar.gz";
    sha256 = "1vyw795jxg7d9ac7hlybink0jgkrybjcbzh1gcq69ck4ggqc6bxn";
  };

  nativeBuildInputs = [ pkg-config python texinfo ];
  buildInputs = [ gfortran texinfo ]
    ++ optional (boost != null) boost;

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

  inherit doCheck;
  checkTarget = "check-testsuite check-examples";

  meta = with lib; {
    description = "Fast multi-dimensional array library for C++";
    homepage = https://sourceforge.net/projects/blitz/;
    license = licenses.lgpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ToxicFrog ];

    longDescription = ''
      Blitz++ is a C++ class library for scientific computing which provides
      performance on par with Fortran 77/90. It uses template techniques to
      achieve high performance. Blitz++ provides dense arrays and vectors,
      random number generators, and small vectors (useful for representing
      multicomponent or vector fields).
    '';
  };
}
