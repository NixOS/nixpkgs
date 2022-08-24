{ lib, stdenv, icu, expat, zlib, bzip2, python ? null, fixDarwinDylibNames, libiconv
, boost-build
, fetchpatch
, which
, toolset ? /**/ if stdenv.cc.isClang  then "clang"
            else if stdenv.cc.isGNU    then "gcc"
            else null
, enableRelease ? true
, enableDebug ? false
, enableSingleThreaded ? false
, enableMultiThreaded ? true
, enableShared ? !(with stdenv.hostPlatform; isStatic || libc == "msvcrt") # problems for now
, enableStatic ? !enableShared
, enablePython ? false
, enableNumpy ? false
, taggedLayout ? ((enableRelease && enableDebug) || (enableSingleThreaded && enableMultiThreaded) || (enableShared && enableStatic))
, patches ? []
, boostBuildPatches ? []
, useMpi ? false
, mpi
, extraB2Args ? []

# Attributes inherit from specific versions
, version, src
, ...
}:

# We must build at least one type of libraries
assert enableShared || enableStatic;

assert enableNumpy -> enablePython;

# Boost <1.69 can't be built on linux with clang >8, because pth was removed
assert with lib; (stdenv.isLinux && toolset == "clang" && versionAtLeast stdenv.cc.version "8.0.0") -> versionAtLeast version "1.69";

with lib;
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

  needUserConfig = stdenv.hostPlatform != stdenv.buildPlatform || useMpi || (stdenv.isDarwin && enableShared);

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
    "architecture=${if stdenv.hostPlatform.isMips64
                    then if versionOlder version "1.78" then "mips1" else "mips"
                    else toString stdenv.hostPlatform.parsed.cpu.family}"
    "binary-format=${toString stdenv.hostPlatform.parsed.kernel.execFormat.name}"
    "target-os=${toString stdenv.hostPlatform.parsed.kernel.name}"

    # adapted from table in boost manual
    # https://www.boost.org/doc/libs/1_66_0/libs/context/doc/html/context/architectures.html
    "abi=${if stdenv.hostPlatform.parsed.cpu.family == "arm" then "aapcs"
           else if stdenv.hostPlatform.isWindows then "ms"
           else if stdenv.hostPlatform.isMips32 then "o32"
           else if stdenv.hostPlatform.isMips64n64 then "n64"
           else "sysv"}"
  ] ++ optional (link != "static") "runtime-link=${runtime-link}"
    ++ optional (variant == "release") "debug-symbols=off"
    ++ optional (toolset != null) "toolset=${toolset}"
    ++ optional (!enablePython) "--without-python"
    ++ optional needUserConfig "--user-config=user-config.jam"
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
  # Fix compiler warning with GCC >= 8; TODO: patch may apply to older versions
  ++ optional (versionAtLeast version "1.65" && versionOlder version "1.67")
    (fetchpatch {
      url = "https://github.com/boostorg/mpl/commit/f48fd09d021db9a28bd7b8452c175897e1af4485.patch";
      sha256 = "15d2a636hhsb1xdyp44x25dyqfcaws997vnp9kl1mhzvxjzz7hb0";
      stripLen = 1;
    })
  ++ optional (versionAtLeast version "1.65" && versionOlder version "1.70") (fetchpatch {
    # support for Mips64n64 appeared in boost-context 1.70; this patch won't apply to pre-1.65 cleanly
    url = "https://github.com/boostorg/context/commit/e3f744a1862164062d579d1972272d67bdaa9c39.patch";
    sha256 = "sha256-qjQy1b4jDsIRrI+UYtcguhvChrMbGWO0UlEzEJHYzRI=";
    stripLen = 1;
    extraPrefix = "libs/context/";
  })
  ++ optional (versionAtLeast version "1.70" && versionOlder version "1.73") ./cmake-paths.patch
  ++ optional (versionAtLeast version "1.73") ./cmake-paths-173.patch
  ++ optional (version == "1.77.0") (fetchpatch {
    url = "https://github.com/boostorg/math/commit/7d482f6ebc356e6ec455ccb5f51a23971bf6ce5b.patch";
    relative = "include";
    sha256 = "sha256-KlmIbixcds6GyKYt1fx5BxDIrU7msrgDdYo9Va/KJR4=";
  });

  meta = {
    homepage = "http://boost.org/";
    description = "Collection of C++ libraries";
    license = licenses.boost;
    platforms = platforms.unix ++ platforms.windows;
    badPlatforms = optional (versionOlder version "1.59") "aarch64-linux"
                 ++ optional ((versionOlder version "1.57") || version == "1.58") "x86_64-darwin"
                 ++ optionals (versionOlder version "1.73") lib.platforms.riscv;
    maintainers = with maintainers; [ hjones2199 ];

    broken =
      # boost-context lacks support for the N32 ABI on mips64.  The build
      # will succeed, but packages depending on boost-context will fail with
      # a very cryptic error message.
      stdenv.hostPlatform.isMips64n32 ||
      # the patch above does not apply cleanly to pre-1.65 boost
      (stdenv.hostPlatform.isMips64n64 && (versionOlder version "1.65"));
  };

  passthru = {
    inherit boostBuildPatches;
  };

  preConfigure = optionalString useMpi ''
    cat << EOF >> user-config.jam
    using mpi : ${mpi}/bin/mpiCC ;
    EOF
  ''
  # On darwin we need to add the `$out/lib` to the libraries' rpath explicitly,
  # otherwise the dynamic linker is unable to resolve the reference to @rpath
  # when the boost libraries want to load each other at runtime.
  + optionalString (stdenv.isDarwin && enableShared) ''
    cat << EOF >> user-config.jam
    using clang-darwin : : ${stdenv.cc.targetPrefix}c++
      : <linkflags>"-rpath $out/lib/"
      ;
    EOF
  ''
  # b2 has trouble finding the correct compiler and tools for cross compilation
  # since it apparently ignores $CC, $AR etc. Thus we need to set everything
  # in user-config.jam. To keep things simple we just set everything in an
  # uniform way for clang and gcc (which works thanks to our cc-wrapper).
  # We pass toolset later which will make b2 invoke everything in the right
  # way -- the other toolset in user-config.jam will be ignored.
  + optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    cat << EOF >> user-config.jam
    using gcc : cross : ${stdenv.cc.targetPrefix}c++
      : <archiver>$AR
        <ranlib>$RANLIB
      ;

    using clang : cross : ${stdenv.cc.targetPrefix}c++
      : <archiver>$AR
        <ranlib>$RANLIB
      ;
    EOF
  '';

  NIX_CFLAGS_LINK = lib.optionalString stdenv.isDarwin
                      "-headerpad_max_install_names";

  enableParallelBuilding = true;

  nativeBuildInputs = [ which boost-build ]
    ++ optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ expat zlib bzip2 libiconv ]
    ++ optional (stdenv.hostPlatform == stdenv.buildPlatform) icu
    ++ optional enablePython python
    ++ optional enableNumpy python.pkgs.numpy;

  configureScript = "./bootstrap.sh";
  configurePlatforms = [];
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  configureFlags = [
    "--includedir=$(dev)/include"
    "--libdir=$(out)/lib"
    "--with-bjam=b2" # prevent bootstrapping b2 in configurePhase
  ] ++ optional enablePython "--with-python=${python.interpreter}"
    ++ optional (toolset != null) "--with-toolset=${toolset}"
    ++ [ (if stdenv.hostPlatform == stdenv.buildPlatform then "--with-icu=${icu.dev}" else "--without-icu") ];

  buildPhase = ''
    runHook preBuild
    b2 ${b2Args}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # boostbook is needed by some applications
    mkdir -p $dev/share/boostbook
    cp -a tools/boostbook/{xsl,dtd} $dev/share/boostbook/

    # Let boost install everything else
    b2 ${b2Args} install

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
