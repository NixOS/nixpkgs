{ stdenv, fetchurl, icu, expat, zlib, bzip2, python
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? true
, enableStatic ? false
, enablePIC ? false
, enableExceptions ? false
, taggedLayout ? ((enableRelease && enableDebug) || (enableSingleThreaded && enableMultiThreaded) || (enableShared && enableStatic))
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
  layout = if taggedLayout then "tagged" else "system";

  cflags = if (enablePIC && enableExceptions) then
             "cflags=-fPIC -fexceptions cxxflags=-fPIC linkflags=-fPIC"
           else if (enablePIC) then
             "cflags=-fPIC cxxflags=-fPIC linkflags=-fPIC"
           else if (enableExceptions) then
             "cflags=-fexceptions"
           else
             "";
in

stdenv.mkDerivation {
  name = "boost-1.53.0";

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_53_0.tar.bz2";
    sha256 = "15livg6y1l3gdsg6ybvp3y4gp0w3xh1rdcq5bjf0qaw804dh92pq";
  };

  enableParallelBuilding = true;

  buildInputs = [icu expat zlib bzip2 python];

  configureScript = "./bootstrap.sh";
  configureFlags = "--with-icu=${icu} --with-python=${python}/bin/python";

  buildPhase = "./b2 -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=${layout} variant=${variant} threading=${threading} link=${link} ${cflags} install";

  # normal install does not install bjam, this is a separate step
  installPhase = ''
    cd tools/build/v2
    sh bootstrap.sh
    ./b2 -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=${layout} variant=${variant} threading=${threading} link=${link} ${cflags} install
  '';

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
      ./b2 -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat.hostDrv}/include -sEXPAT_LIBPATH=${expat.hostDrv}/lib --layout=${layout} --user-config=user-config.jam toolset=gcc-cross variant=${variant} threading=${threading} link=${link} ${cflags} --without-python install
    '';
  };
}
