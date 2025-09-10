{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  getVersionFile,
  monorepoSrc ? null,
  fetchpatch,
  autoreconfHook269,
  runCommand,
  gettext,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libstdcxx";
  inherit version;

  src = runCommand "libstdcxx-src-${version}" { src = monorepoSrc; } ''
    runPhase unpackPhase

    mkdir -p "$out/gcc"
    cp gcc/BASE-VER "$out/gcc"
    cp gcc/DATESTAMP "$out/gcc"

    mkdir -p "$out/libgcc"
    cp libgcc/gthr*.h "$out/libgcc"
    cp libgcc/unwind-pe.h "$out/libgcc"

    cp -r libstdc++-v3 "$out"

    cp -r libiberty "$out"
    cp -r include "$out"
    cp -r contrib "$out"

    cp -r config "$out"
    cp -r multilib.am "$out"

    cp config.guess "$out"
    cp config.rpath "$out"
    cp config.sub "$out"
    cp config-ml.in "$out"
    cp ltmain.sh "$out"
    cp install-sh "$out"
    cp mkinstalldirs "$out"

    [[ -f MD5SUMS ]]; cp MD5SUMS "$out"
  '';

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    (fetchpatch {
      name = "custom-threading-model.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250716204545.1063669-1-git@JohnEricson.me/raw";
      hash = "sha256-jPP0+MoPLtCwWcW6doO6KHCppwAYK40qNVyriLXcGOg=";
      includes = [
        "config/*"
        "libstdc++-v3/*"
      ];
    })
    (getVersionFile "libstdcxx/force-regular-dirs.patch")
  ];

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  preAutoreconf = ''
    sourceRoot=$(readlink -e "./libstdc++-v3")
    cd $sourceRoot
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook269
    gettext
  ];

  preConfigure = ''
    cd "$buildRoot"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"
  '';

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--disable-dependency-tracking"
    "gcc_cv_target_thread_file=posix"
    "cross_compiling=true"
    "--disable-multilib"

    "--enable-clocale=gnu"
    "--disable-libstdcxx-pch"
    "--disable-vtable-verify"
    "--enable-libstdcxx-visibility"
    "--with-default-libstdcxx-abi=new"
  ];

  hardeningDisable = [
    # PATH_MAX
    "fortify"
  ];

  postInstall = ''
    moveToOutput lib/libstdc++.modules.json "$dev"
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/onlinedocs/libstdc++";
    description = "GNU C++ Library";
  };
})
