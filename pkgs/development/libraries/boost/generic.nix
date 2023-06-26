{ lib, stdenv, icu, expat, zlib, bzip2, zstd, xz, python ? null, fixDarwinDylibNames, libiconv, libxcrypt
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
, enableIcu ? stdenv.hostPlatform == stdenv.buildPlatform
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

let

  variant = lib.concatStringsSep ","
    (lib.optional enableRelease "release" ++
     lib.optional enableDebug "debug");

  threading = lib.concatStringsSep ","
    (lib.optional enableSingleThreaded "single" ++
     lib.optional enableMultiThreaded "multi");

  link = lib.concatStringsSep ","
    (lib.optional enableShared "shared" ++
     lib.optional enableStatic "static");

  runtime-link = if enableShared then "shared" else "static";

  # To avoid library name collisions
  layout = if taggedLayout then "tagged" else "system";

  needUserConfig = stdenv.hostPlatform != stdenv.buildPlatform || useMpi || (stdenv.isDarwin && enableShared);

  b2Args = lib.concatStringsSep " " ([
    "--includedir=$dev/include"
    "--libdir=$out/lib"
    "-j$NIX_BUILD_CORES"
    "--layout=${layout}"
    "variant=${variant}"
    "threading=${threading}"
    "link=${link}"
    "-sEXPAT_INCLUDE=${expat.dev}/include"
    "-sEXPAT_LIBPATH=${expat.out}/lib"

    # TODO: make this unconditional
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform ||
                  # required on mips; see 61d9f201baeef4c4bb91ad8a8f5f89b747e0dfe4
                  (stdenv.hostPlatform.isMips && lib.versionAtLeast version "1.79")) [
    "address-model=${toString stdenv.hostPlatform.parsed.cpu.bits}"
    "architecture=${if stdenv.hostPlatform.isMips64
                    then if lib.versionOlder version "1.78" then "mips1" else "mips"
                    else if stdenv.hostPlatform.parsed.cpu.name == "s390x" then "s390x"
                    else toString stdenv.hostPlatform.parsed.cpu.family}"
    # env in host triplet for Mach-O is "macho", but boost binary format for Mach-O is "mach-o"
    "binary-format=${if stdenv.hostPlatform.parsed.kernel.execFormat == lib.systems.parse.execFormats.macho
                     then "mach-o"
                     else toString stdenv.hostPlatform.parsed.kernel.execFormat.name}"
    "target-os=${toString stdenv.hostPlatform.parsed.kernel.name}"

    # adapted from table in boost manual
    # https://www.boost.org/doc/libs/1_66_0/libs/context/doc/html/context/architectures.html
    "abi=${if stdenv.hostPlatform.parsed.cpu.family == "arm" then "aapcs"
           else if stdenv.hostPlatform.isWindows then "ms"
           else if stdenv.hostPlatform.isMips32 then "o32"
           else if stdenv.hostPlatform.isMips64n64 then "n64"
           else "sysv"}"
  ] ++ lib.optional (link != "static") "runtime-link=${runtime-link}"
    ++ lib.optional (variant == "release") "debug-symbols=off"
    ++ lib.optional (toolset != null) "toolset=${toolset}"
    ++ lib.optional (!enablePython) "--without-python"
    ++ lib.optional needUserConfig "--user-config=user-config.jam"
    ++ lib.optional (stdenv.buildPlatform.isDarwin && stdenv.hostPlatform.isLinux) "pch=off"
    ++ lib.optionals (stdenv.hostPlatform.libc == "msvcrt") [
    "threadapi=win32"
  ] ++ extraB2Args
  );

in

stdenv.mkDerivation {
  pname = "boost";

  inherit src version;

  patchFlags = [];

  patches = patches
  ++ lib.optional stdenv.isDarwin ./darwin-no-system-python.patch
  ++ [ ./cmake-paths-173.patch ]
  ++ lib.optional (version == "1.77.0") (fetchpatch {
    url = "https://github.com/boostorg/math/commit/7d482f6ebc356e6ec455ccb5f51a23971bf6ce5b.patch";
    relative = "include";
    sha256 = "sha256-KlmIbixcds6GyKYt1fx5BxDIrU7msrgDdYo9Va/KJR4=";
  });

  meta = with lib; {
    homepage = "http://boost.org/";
    description = "Collection of C++ libraries";
    license = licenses.boost;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ hjones2199 ];

    broken =
      # boost-context lacks support for the N32 ABI on mips64.  The build
      # will succeed, but packages depending on boost-context will fail with
      # a very cryptic error message.
      stdenv.hostPlatform.isMips64n32;
  };

  passthru = {
    inherit boostBuildPatches;
  };

  preConfigure = lib.optionalString useMpi ''
    cat << EOF >> user-config.jam
    using mpi : ${mpi}/bin/mpiCC ;
    EOF
  ''
  # On darwin we need to add the `$out/lib` to the libraries' rpath explicitly,
  # otherwise the dynamic linker is unable to resolve the reference to @rpath
  # when the boost libraries want to load each other at runtime.
  + lib.optionalString (stdenv.isDarwin && enableShared) ''
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
  + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
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
  ''
  # b2 needs to be explicitly told how to find Python when cross-compiling
  + lib.optionalString enablePython ''
    cat << EOF >> user-config.jam
    using python : : ${python.interpreter}
      : ${python}/include/python${python.pythonVersion}
      : ${python}/lib
      ;
    EOF
  '';

  NIX_CFLAGS_LINK = lib.optionalString stdenv.isDarwin
                      "-headerpad_max_install_names";

  enableParallelBuilding = true;

  nativeBuildInputs = [ which boost-build ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = [ expat zlib bzip2 libiconv ]
    ++ lib.optional (lib.versionAtLeast version "1.69") zstd
    ++ [ xz ]
    ++ lib.optional enableIcu icu
    ++ lib.optionals enablePython [ libxcrypt python ]
    ++ lib.optional enableNumpy python.pkgs.numpy;

  configureScript = "./bootstrap.sh";
  configurePlatforms = [];
  dontDisableStatic = true;
  dontAddStaticConfigureFlags = true;
  configureFlags = [
    "--includedir=$(dev)/include"
    "--libdir=$(out)/lib"
    "--with-bjam=b2" # prevent bootstrapping b2 in configurePhase
  ] ++ lib.optional (toolset != null) "--with-toolset=${toolset}"
    ++ [ (if enableIcu then "--with-icu=${icu.dev}" else "--without-icu") ];

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
  '' + lib.optionalString (stdenv.hostPlatform.libc == "msvcrt") ''
    $RANLIB "$out/lib/"*.a
  '';

  outputs = [ "out" "dev" ];
  setOutputFlags = false;
}
