{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, gfortran
, texinfo
, python2
, boost
  # Select SIMD alignment width (in bytes) for vectorization.
, simdWidth ? 1
  # Pad arrays to simdWidth by default?
  # Note: Only useful if simdWidth > 1
, enablePadding ? false
  # Activate serialization through Boost.Serialize?
, enableSerialization ? true
  # Activate test-suite?
  # WARNING: Some of the tests require up to 1700MB of memory to compile.
, doCheck ? true
}:

let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "blitz++";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "blitzpp";
    repo = "blitz";
    rev = "1.0.1";
    sha256 = "0nq84vwvvbq7m0my6h835ijfw53bxdp42qjc6kjhk436888qy9rh";
  };

  nativeBuildInputs = [ pkg-config python2 texinfo ];
  buildInputs = [ gfortran texinfo boost ];

  configureFlags =
    [
      "--enable-shared"
      "--disable-static"
      "--enable-fortran"
      "--enable-optimize"
      "--with-pic=yes"
      "--enable-html-docs"
      "--disable-doxygen"
      "--disable-dot"
      "--disable-latex-docs"
      "--enable-simd-width=${toString simdWidth}"
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
    ] ++ optional enablePadding "--enable-array-length-padding"
    ++ optional enableSerialization "--enable-serialization"
    ++ optional stdenv.is64bit "--enable-64bit";

  # skip broken library name detection
  ax_boost_user_serialization_lib = lib.optionalString stdenv.isDarwin "boost_serialization";

  enableParallelBuilding = true;

  inherit doCheck;
  checkTarget = "check-testsuite check-examples";

  meta = with lib; {
    description = "Fast multi-dimensional array library for C++";
    homepage = "https://sourceforge.net/projects/blitz/";
    license = licenses.lgpl3;
    platforms = platforms.unix;
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
