{ stdenv, fetchurl, icu, expat, zlib, bzip2, python, fixDarwinDylibNames
, toolset ? null
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

  cflags = if enablePIC && enableExceptions then
             "cflags=\"-fPIC -fexceptions\" cxxflags=-fPIC linkflags=-fPIC"
           else if enablePIC then
             "cflags=-fPIC cxxflags=-fPIC linkflags=-fPIC"
           else if enableExceptions then
             "cflags=-fexceptions"
           else
             "";

  withToolset = stdenv.lib.optionalString (toolset != null) " --with-toolset=${toolset}";
in

let res = stdenv.mkDerivation {
  name = "boost-1.55.0";

  meta = {
    homepage = "http://boost.org/";
    description = "Collection of C++ libraries";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_55_0.tar.bz2";
    sha256 = "0lkv5dzssbl5fmh2nkaszi8x9qbj80pr4acf9i26sj3rvlih1w7z";
  };

  enableParallelBuilding = true;

  buildInputs =
    [ icu expat zlib bzip2 python ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  configureScript = "./bootstrap.sh";
  configureFlags = "--with-icu=${icu} --with-python=${python}/bin/python" + withToolset;

  buildPhase = "${stdenv.lib.optionalString (toolset == "clang") "unset NIX_ENFORCE_PURITY; "}./b2 -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=${layout} variant=${variant} threading=${threading} link=${link} ${cflags} install${withToolset}";

  # normal install does not install bjam, this is a separate step
  installPhase = ''
    cd tools/build/v2
    sh bootstrap.sh${withToolset}
    ./b2 -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=${layout} variant=${variant} threading=${threading} link=${link} ${cflags} install${withToolset}
    rm $out/bin/bjam
    ln -s $out/bin/b2 $out/bin/bjam
    rm -rf $out/share/boost-build/example
  '';

  crossAttrs = rec {
    buildInputs = [ expat.crossDrv zlib.crossDrv bzip2.crossDrv ];
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
      ./b2 -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat.crossDrv}/include -sEXPAT_LIBPATH=${expat.crossDrv}/lib --layout=${layout} --user-config=user-config.jam toolset=gcc-cross variant=${variant} threading=${threading} link=${link} ${cflags} --without-python install
    '';
  };
}; in res // { lib = res; }
