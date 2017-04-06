{ stdenv, fetchurl, icu, expat, zlib, bzip2, python, fixDarwinDylibNames, libiconv
, toolset ? if stdenv.cc.isClang then "clang" else null
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? !(stdenv.cross.libc or null == "msvcrt") # problems for now
, enableStatic ? !enableShared
, enablePIC ? false
, enableExceptions ? false
, taggedLayout ? ((enableRelease && enableDebug) || (enableSingleThreaded && enableMultiThreaded) || (enableShared && enableStatic))
, patches ? null
, mpi ? null

# Attributes inherit from specific versions
, version, src
, ...
}:

# We must build at least one type of libraries
assert !enableShared -> enableStatic;

with stdenv.lib;
let

  variant = concatStringsSep ","
    (optional enableRelease "release" ++
     optional enableDebug "debug");

  threading = concatStringsSep ","
    (optional enableSingleThreaded "single" ++
     optional enableMultiThreaded "multi");

  link = concatStringsSep ","
    (optional enableShared "shared" ++
     optional enableStatic "static");

  runtime-link = if enableShared then "shared" else "static";

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

  withToolset = stdenv.lib.optionalString (toolset != null) "--with-toolset=${toolset}";

  genericB2Flags = [
    "--includedir=$dev/include"
    "--libdir=$out/lib"
    "-j$NIX_BUILD_CORES"
    "--layout=${layout}"
    "variant=${variant}"
    "threading=${threading}"
  ] ++ optional (link != "static") "runtime-link=${runtime-link}" ++ [
    "link=${link}"
    "${cflags}"
  ] ++ optional (variant == "release") "debug-symbols=off";

  nativeB2Flags = [
    "-sEXPAT_INCLUDE=${expat.dev}/include"
    "-sEXPAT_LIBPATH=${expat.out}/lib"
  ] ++ optional (toolset != null) "toolset=${toolset}"
    ++ optional (mpi != null) "--user-config=user-config.jam";
  nativeB2Args = concatStringsSep " " (genericB2Flags ++ nativeB2Flags);

  crossB2Flags = [
    "-sEXPAT_INCLUDE=${expat.crossDrv}/include"
    "-sEXPAT_LIBPATH=${expat.crossDrv}/lib"
    "--user-config=user-config.jam"
    "toolset=gcc-cross"
    "--without-python"
  ] ++ optionals (stdenv.cross.libc == "msvcrt") [
    "target-os=windows"
    "threadapi=win32"
    "binary-format=pe"
    "address-model=${if hasPrefix "x86_64-" stdenv.cross.config then "64" else "32"}"
    "architecture=x86"
  ];
  crossB2Args = concatStringsSep " " (genericB2Flags ++ crossB2Flags);

  builder = b2Args: ''
    ./b2 ${b2Args}
  '';

  installer = b2Args: ''
    # boostbook is needed by some applications
    mkdir -p $dev/share/boostbook
    cp -a tools/boostbook/{xsl,dtd} $dev/share/boostbook/

    # Let boost install everything else
    ./b2 ${b2Args} install
  '';

  commonConfigureFlags = [
    "--includedir=$(dev)/include"
    "--libdir=$(out)/lib"
  ];

  fixup = ''
    # Make boost header paths relative so that they are not runtime dependencies
    (
      cd "$dev"
      find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
        -exec sed '1i#line 1 "{}"' -i '{}' \;
    )
  '' + optionalString (stdenv.cross.libc or null == "msvcrt") ''
    ${stdenv.cross.config}-ranlib "$out/lib/"*.a
  '';

in

stdenv.mkDerivation {
  name = "boost-${version}";

  inherit src patches;

  meta = {
    homepage = "http://boost.org/";
    description = "Collection of C++ libraries";
    license = stdenv.lib.licenses.boost;

    platforms = (if versionOlder version "1.59" then remove "aarch64-linux" else id) platforms.unix;
    maintainers = with maintainers; [ peti wkennington ];
  };

  preConfigure = ''
    if test -f tools/build/src/tools/clang-darwin.jam ; then
        substituteInPlace tools/build/src/tools/clang-darwin.jam \
          --replace '@rpath/$(<[1]:D=)' "$out/lib/\$(<[1]:D=)";
    fi;
  '' + optionalString (mpi != null) ''
    cat << EOF > user-config.jam
    using mpi : ${mpi}/bin/mpiCC ;
    EOF
  '';

  NIX_CFLAGS_LINK = stdenv.lib.optionalString stdenv.isDarwin
                      "-headerpad_max_install_names";

  enableParallelBuilding = true;

  buildInputs = [ expat zlib bzip2 libiconv ]
    ++ stdenv.lib.optionals (! stdenv ? cross) [ python icu ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  configureScript = "./bootstrap.sh";
  configureFlags = commonConfigureFlags
    ++ [ "--with-python=${python.interpreter}" ]
    ++ optional (! stdenv ? cross) "--with-icu=${icu.dev}"
    ++ optional (toolset != null) "--with-toolset=${toolset}";

  buildPhase = builder nativeB2Args;

  installPhase = installer nativeB2Args;

  postFixup = fixup;

  outputs = [ "out" "dev" ];
  setOutputFlags = false;

  crossAttrs = rec {
    # We want to substitute the contents of configureFlags, removing thus the
    # usual --build and --host added on cross building.
    preConfigure = ''
      export configureFlags="--without-icu ${concatStringsSep " " commonConfigureFlags}"
      cat << EOF > user-config.jam
      using gcc : cross : $crossConfig-g++ ;
      EOF
    '';
    buildPhase = builder crossB2Args;
    installPhase = installer crossB2Args;
    postFixup = fixup;
  } // optionalAttrs (stdenv.cross.libc == "msvcrt") {
    patches = fetchurl {
      url = "https://svn.boost.org/trac/boost/raw-attachment/ticket/7262/"
          + "boost-mingw.patch";
      sha256 = "0s32kwll66k50w6r5np1y5g907b7lcpsjhfgr7rsw7q5syhzddyj";
    };

    patchFlags = "-p0";
  };
}
