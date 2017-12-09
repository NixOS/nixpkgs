{ stdenv, fetchurl, which, icu, expat, zlib, bzip2, python, fixDarwinDylibNames, libiconv
, buildPlatform, hostPlatform, buildPackages
, toolset ? if stdenv.cc.isClang then "clang" else null
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? !(hostPlatform.libc == "msvcrt") # problems for now
, enableStatic ? !enableShared
, enablePIC ? false
, enableExceptions ? false
, enablePython ? hostPlatform == buildPlatform
, enableNumpy ? enablePython && stdenv.lib.versionAtLeast version "1.65"
, taggedLayout ? ((enableRelease && enableDebug) || (enableSingleThreaded && enableMultiThreaded) || (enableShared && enableStatic))
, patches ? []
, mpi ? null

# Attributes inherit from specific versions
, version, src
, ...
}:

# We must build at least one type of libraries
assert enableShared || enableStatic;

assert enablePython -> hostPlatform == buildPlatform;
assert enableNumpy -> enablePython;

# The plan for cross-compilation:
#
# Cross-compiling boost is a bit of a nightmare due to its build system,
# boost-build. When not cross-compiling the bootstrap.sh script will compiling
# bjam, the boost build system's executable, and then use it to build the library.
#
# In principle it is possible for the bootstrap.sh script to use a cross
# compiler to build bjam. However, in practice boost-build is so terribly broken
# that this is all but impossible (see, for instance, boost ticket #5917, which
# makes it impossible to specify a non-standard compiler path to bootstrap.sh).
#
# Because of this, we instead compile and package the bjam utility when not
# cross-compiling and then use it as a nativeBuildInput when cross-compiling.

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

  cflags = concatStringsSep " "
    (optional (enablePIC) "-fPIC" ++
     optional (enableExceptions) "-fexceptions");

  cxxflags = optionalString (enablePIC) "-fPIC";

  linkflags = optionalString (enablePIC) "-fPIC";

  withToolset = stdenv.lib.optionalString (toolset != null) "--with-toolset=${toolset}";

  b2Args = concatStringsSep " " ([
    "--includedir=$dev/include"
    "--libdir=$out/lib"
    "-j$NIX_BUILD_CORES"
    "--layout=${layout}"
    "variant=${variant}"
    "threading=${threading}"
    "runtime-link=${runtime-link}"
    "link=${link}"
    "-sEXPAT_INCLUDE=${expat.dev}/include"
    "-sEXPAT_LIBPATH=${expat.out}/lib"
  ] ++ optionals (cflags != "") [
    "cflags=\"${cflags}\""
    "cxxflags=\"${cflags}\""
    "linkflags=\"${cflags}\""
  ] ++ optional (variant == "release") "debug-symbols=off"
    ++ optional (toolset != null) "toolset=${toolset}"
    ++ optional (mpi != null || hostPlatform != buildPlatform) "--user-config=user-config.jam"
    ++ optionals (hostPlatform.libc == "msvcrt") [
    "target-os=windows"
    "threadapi=win32"
    "binary-format=pe"
    "address-model=${toString hostPlatform.parsed.cpu.bits}"
    "architecture=x86"
  ] ++ optional (variant == "release") "debug-symbols=off"
    ++ optional (enablePython) "--with-python"
    ++ optional (hostPlatform != buildPlatform) "toolset=gcc-cross");

  b2 = if hostPlatform == buildPlatform then "./b2" else "${buildPackages.boost.bjam}/bin/bjam";

in

stdenv.mkDerivation {
  name = "boost-${version}";

  inherit src;

  patchFlags = optionalString (hostPlatform.libc == "msvcrt") "-p0";
  patches = patches ++ optional (hostPlatform.libc == "msvcrt") (fetchurl {
    url = "https://svn.boost.org/trac/boost/raw-attachment/tickaet/7262/"
        + "boost-mingw.patch";
    sha256 = "0s32kwll66k50w6r5np1y5g907b7lcpsjhfgr7rsw7q5syhzddyj";
  });

  meta = {
    homepage = http://boost.org/;
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
    cat << EOF >> user-config.jam
    using mpi : ${mpi}/bin/mpiCC ;
    EOF
  '' + optionalString (hostPlatform != buildPlatform) ''
    cat << EOF > user-config.jam
    using gcc : cross :
        ${stdenv.cc.targetPrefix}c++ :
        <archiver>${stdenv.cc.targetPrefix}ar
        <ranlib>${stdenv.cc.targetPrefix}ranlib
        ;
    EOF
  '';

  NIX_CFLAGS_LINK = stdenv.lib.optionalString stdenv.isDarwin
                      "-headerpad_max_install_names";

  enableParallelBuilding = true;

  buildInputs = [ expat zlib bzip2 libiconv ]
    ++ optional (hostPlatform == buildPlatform) icu
    ++ optional stdenv.isDarwin fixDarwinDylibNames
    ++ optional enablePython python
    ++ optional enableNumpy python.pkgs.numpy;
  nativeBuildInputs = [ which ]
    ++ optional (hostPlatform != buildPlatform) buildPackages.boost.bjam;

  configureScript = "./bootstrap.sh";
  configurePlatforms = [];
  configureFlags = [
    "--includedir=$(dev)/include"
    "--libdir=$(out)/lib"
  ] ++ optional (toolset != null) "--with-toolset=${toolset}"
    ++ (if hostPlatform == buildPlatform then [
      "--with-icu=${icu.dev}"
      "--with-python=${python.interpreter}"
    ] else [
      "--without-icu"
      "--with-bjam=${buildPackages.boost.bjam}/bin/bjam"
    ]);

  buildPhase = ''
    export AR=${stdenv.cc.targetPrefix}ar
    export RANLIB=${stdenv.cc.targetPrefix}ranlib
    ${b2} ${b2Args}
  '';

  installPhase = ''
    # boostbook is needed by some applications
    mkdir -p $dev/share/boostbook
    cp -a tools/boostbook/{xsl,dtd} $dev/share/boostbook/

    # Let boost install everything else
    ${b2} ${b2Args} install

  '' # See the plan for cross-compiling above.
     + optionalString (hostPlatform == buildPlatform) ''
    mkdir -p $bjam/bin
    cp ./bjam $bjam/bin
  '';

  postFixup = ''
    # Make boost header paths relative so that they are not runtime dependencies
    cd "$dev" && find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
      -exec sed '1i#line 1 "{}"' -i '{}' \;
  '' + optionalString (hostPlatform.libc == "msvcrt") ''
    ${stdenv.cc.targetPrefix}ranlib "$out/lib/"*.a
  '';

  outputs = [ "out" "dev" ]
    # See the plan for cross-compiling above.
    ++ optional (buildPlatform == hostPlatform) "bjam";
  setOutputFlags = false;
}
