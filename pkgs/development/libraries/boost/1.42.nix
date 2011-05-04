{ stdenv, fetchurl, icu, expat, zlib, bzip2, python
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? true
, enableStatic ? false
, enablePIC ? false
}:

let

  variant = stdenv.lib.concatStringsSep ","
    (stdenv.lib.optional enableRelease "release" ++
     stdenv.lib.optional enableDebug "debug");

  threading = stdenv.lib.concatStringsSep ","
    (stdenv.lib.optional enableSingleThreaded "single" ++
     stdenv.lib.optional enableMultiThreaded "multi");

  link = stdenv.lib.concatStringsSep ","
    (stdenv.lib.optional enableShared "shared" ++
     stdenv.lib.optional enableStatic "static");

  # To avoid library name collisions
  finalLayout = if ((enableRelease && enableDebug) ||
    (enableSingleThreaded && enableMultiThreaded) ||
    (enableShared && enableStatic)) then
    "tagged" else "system";

  cflags = if (enablePIC) then "cflags=-fPIC cxxflags=-fPIC linkflags=-fPIC" else "";

in

stdenv.mkDerivation {
  name = "boost-1.42.0";

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    maintainers = [ stdenv.lib.maintainers.simons ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_42_0.tar.bz2";
    sha256 = "02g6m6f7m11ig93p5sx7sfq75c15y9kn2pa3csn1bkjhs9dvj7jb";
  };

  enableParallelBuilding = true;

  buildInputs = [icu expat zlib bzip2 python];

  configureScript = "./bootstrap.sh";
  configureFlags = "--with-icu=${icu} --with-python=${python}/bin/python";

  buildPhase = "./bjam -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=${finalLayout} variant=${variant} threading=${threading} link=${link} ${cflags} install";

  installPhase = ":";

  crossAttrs = rec {
    buildInputs = [ expat.hostDrv zlib.hostDrv bzip2.hostDrv ];
    # all buildInputs set previously fell into propagatedBuildInputs, as usual, so we have to
    # override them.
    propagatedBuildInputs = buildInputs;
    # We want to substitute the contents of configureFlags, removing thus the
    # usual --build and --host added on cross building.
    preConfigure = ''
      export configureFlags="--prefix=$out --without-icu"
    '';
    buildPhase = ''
      set -x
      cat << EOF > user-config.jam
      using gcc : cross : $crossConfig-g++ ;
      EOF
      ./bjam -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat.hostDrv}/include -sEXPAT_LIBPATH=${expat.hostDrv}/lib --layout=${finalLayout} --user-config=user-config.jam toolset=gcc-cross variant=${variant} threading=${threading} link=${link} ${cflags} --without-python install
    '';
  };
}
