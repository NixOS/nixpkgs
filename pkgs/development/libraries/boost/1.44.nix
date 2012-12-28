{ stdenv, fetchurl, icu, expat, zlib, bzip2, python
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? true
, enableStatic ? false
, enablePIC ? false
, taggedLayout ? false
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
  finalLayout = if (taggedLayout || (enableRelease && enableDebug) ||
    (enableSingleThreaded && enableMultiThreaded) ||
    (enableShared && enableStatic)) then
    "tagged" else "system";

  cflags = if (enablePIC) then "cflags=-fPIC cxxflags=-fPIC linkflags=-fPIC" else "";

in

stdenv.mkDerivation {
  name = "boost-1.44.0";

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    maintainers = [ stdenv.lib.maintainers.simons ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_44_0.tar.bz2";
    sha256 = "1nvq36mvzr1fr85q0jh86rk3bk65s1y55jgqgzfg3lcpkl12ihs5";
  };

  enableParallelBuilding = true;

  buildInputs = [icu expat zlib bzip2 python];

  configureScript = "./bootstrap.sh";
  configureFlags = "--with-icu=${icu} --with-python=${python}/bin/python";

  buildPhase = "./bjam -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat}/include -sEXPAT_LIBPATH=${expat}/lib --layout=${finalLayout} variant=${variant} threading=${threading} link=${link} ${cflags} install";

  installPhase = ":";

  patches = [
    # Patch to get rid of following error, experienced by some packages like encfs, bitcoin:
    #    terminate called after throwing an instance of 'std::runtime_error'
    #    what():  locale::facet::_S_create_c_locale name not valid
    (fetchurl {
       url = https://svn.boost.org/trac/boost/raw-attachment/ticket/4688/boost_filesystem.patch ;
       sha256 = "15k91ihzs6190pnryh4cl0b3c2pjpl9d790mr14x16zq52y7px2d";
     })
  ];

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
      ./bjam -j$NIX_BUILD_CORES -sEXPAT_INCLUDE=${expat.crossDrv}/include -sEXPAT_LIBPATH=${expat.crossDrv}/lib --layout=${finalLayout} --user-config=user-config.jam toolset=gcc-cross variant=${variant} threading=${threading} link=${link} ${cflags} --without-python install
    '';
  };
}
