{ stdenv, icu, expat, zlib, bzip2, python, fixDarwinDylibNames, libiconv
, fetchpatch
, which
, buildPackages
, toolset ? /**/ if stdenv.cc.isClang  then "clang"
            else null
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? !(stdenv.hostPlatform.libc == "msvcrt") # problems for now
, enableStatic ? !enableShared
, enablePython ? false
, enableNumpy ? false
, taggedLayout ? ((enableRelease && enableDebug) || (enableSingleThreaded && enableMultiThreaded) || (enableShared && enableStatic))
, patches ? []
, mpi ? null
, extraB2Args ? []

# Attributes inherit from specific versions
, version, src
, ...
}:

# We must build at least one type of libraries
assert enableShared || enableStatic;

# Python isn't supported when cross-compiling
assert enablePython -> stdenv.hostPlatform == stdenv.buildPlatform;
assert enableNumpy -> enablePython;

# Boost <1.69 can't be build with clang >8, because pth was removed
assert with stdenv.lib; ((toolset == "clang" && !(versionOlder stdenv.cc.version "8.0.0")) -> !(versionOlder version "1.69"));

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

  # Versions of b2 before 1.65 have job limits; specifically:
  #   - Versions before 1.58 support up to 64 jobs[0]
  #   - Versions before 1.65 support up to 256 jobs[1]
  #
  # [0]: https://github.com/boostorg/build/commit/0ef40cb86728f1cd804830fef89a6d39153ff632
  # [1]: https://github.com/boostorg/build/commit/316e26ca718afc65d6170029284521392524e4f8
  jobs =
    if versionOlder version "1.58" then
      "$(($NIX_BUILD_CORES<=64 ? $NIX_BUILD_CORES : 64))"
    else if versionOlder version "1.65" then
      "$(($NIX_BUILD_CORES<=256 ? $NIX_BUILD_CORES : 256))"
    else
      "$NIX_BUILD_CORES";

  b2Args = concatStringsSep " " ([
    "--includedir=$dev/include"
    "--libdir=$out/lib"
    "-j${jobs}"
    "--layout=${layout}"
    "variant=${variant}"
    "threading=${threading}"
    "link=${link}"
    "-sEXPAT_INCLUDE=${expat.dev}/include"
    "-sEXPAT_LIBPATH=${expat.out}/lib"

    # TODO: make this unconditional
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "address-model=${toString stdenv.hostPlatform.parsed.cpu.bits}"
    "architecture=${toString stdenv.hostPlatform.parsed.cpu.family}"
    "binary-format=${toString stdenv.hostPlatform.parsed.kernel.execFormat.name}"
    "target-os=${toString stdenv.hostPlatform.parsed.kernel.name}"

    # adapted from table in boost manual
    # https://www.boost.org/doc/libs/1_66_0/libs/context/doc/html/context/architectures.html
    "abi=${if stdenv.hostPlatform.parsed.cpu.family == "arm" then "aapcs"
           else if stdenv.hostPlatform.isWindows then "ms"
           else if stdenv.hostPlatform.isMips then "o32"
           else "sysv"}"
  ] ++ optional (link != "static") "runtime-link=${runtime-link}"
    ++ optional (variant == "release") "debug-symbols=off"
    ++ optional (toolset != null) "toolset=${toolset}"
    ++ optional (!enablePython) "--without-python"
    ++ optional (mpi != null || stdenv.hostPlatform != stdenv.buildPlatform) "--user-config=user-config.jam"
    ++ optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "threadapi=win32"
  ] ++ extraB2Args
  );

in

stdenv.mkDerivation {
  pname = "boost";

  inherit src version;

  patchFlags = [];

  patches = patches
  ++ optional stdenv.isDarwin (
    if version == "1.55.0"
    then ./darwin-1.55-no-system-python.patch
    else ./darwin-no-system-python.patch)
  # Fix boost-context segmentation faults on ppc64 due to ABI violation
  ++ optional (versionAtLeast version "1.61" &&
               versionOlder version "1.71") (fetchpatch {
    url = "https://github.com/boostorg/context/commit/2354eca9b776a6739112833f64754108cc0d1dc5.patch";
    sha256 = "067m4bjpmcanqvg28djax9a10avmdwhlpfx6gn73kbqqq70dnz29";
    stripLen = 1;
    extraPrefix = "libs/context/";
  })
  ++ optional (and (versionAtLeast version "1.70") (!versionAtLeast version "1.73")) ./cmake-paths.patch
  ++ optional (versionAtLeast version "1.73") ./cmake-paths-173.patch;

  meta = {
    homepage = "http://boost.org/";
    description = "Collection of C++ libraries";
    license = licenses.boost;
    platforms = platforms.unix ++ platforms.windows;
    badPlatforms = optional (versionOlder version "1.59") "aarch64-linux"
                 ++ optional ((versionOlder version "1.57") || version == "1.58") "x86_64-darwin";
    maintainers = with maintainers; [ peti ];
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
  '' + optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    cat << EOF >> user-config.jam
    using gcc : cross : ${stdenv.cc.targetPrefix}c++ ;
    EOF
  '';

  NIX_CFLAGS_LINK = stdenv.lib.optionalString stdenv.isDarwin
                      "-headerpad_max_install_names";

  enableParallelBuilding = true;

  nativeBuildInputs = [ which ]
    ++ optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ expat zlib bzip2 libiconv ]
    ++ optional (stdenv.hostPlatform == stdenv.buildPlatform) icu
    ++ optional enablePython python
    ++ optional enableNumpy python.pkgs.numpy;

  configureScript = "./bootstrap.sh";
  configurePlatforms = [];
  configureFlags = [
    "--includedir=$(dev)/include"
    "--libdir=$(out)/lib"
  ] ++ optional enablePython "--with-python=${python.interpreter}"
    ++ [ (if stdenv.hostPlatform == stdenv.buildPlatform then "--with-icu=${icu.dev}" else "--without-icu") ]
    ++ optional (toolset != null) "--with-toolset=${toolset}";

  buildPhase = ''
    runHook preBuild
    ./b2 ${b2Args}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # boostbook is needed by some applications
    mkdir -p $dev/share/boostbook
    cp -a tools/boostbook/{xsl,dtd} $dev/share/boostbook/

    # Let boost install everything else
    ./b2 ${b2Args} install

    runHook postInstall
  '';

  postFixup = ''
    # Make boost header paths relative so that they are not runtime dependencies
    cd "$dev" && find include \( -name '*.hpp' -or -name '*.h' -or -name '*.ipp' \) \
      -exec sed '1s/^\xef\xbb\xbf//;1i#line 1 "{}"' -i '{}' \;
  '' + optionalString (stdenv.hostPlatform.libc == "msvcrt") ''
    $RANLIB "$out/lib/"*.a
  '';

  outputs = [ "out" "dev" ];
  setOutputFlags = false;
}
