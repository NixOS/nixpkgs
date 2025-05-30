{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  monorepoSrc ? null,
  runCommand,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libssp";
  inherit version;

  src = runCommand "libssp-src-${version}" { src = monorepoSrc; } ''
    runPhase unpackPhase

    mkdir -p "$out/gcc"
    cp gcc/BASE-VER "$out/gcc"
    cp gcc/DATESTAMP "$out/gcc"

    cp -r libssp "$out"

    cp config.guess "$out"
    cp config.rpath "$out"
    cp config.sub "$out"
    cp config-ml.in "$out"
    cp ltmain.sh "$out"
    cp install-sh "$out"
    cp mkinstalldirs "$out"

    [[ -f MD5SUMS ]]; cp MD5SUMS "$out"
  '';

  sourceRoot = "${finalAttrs.src.name}/libssp";

  configurePlatforms = [
    "build"
    "host"
  ];
  configureFlags = [
    "--disable-dependency-tracking"
    "--with-toolexeclibdir=${builtins.placeholder "out" + "/lib"}"
    "cross_compiling=true"
    "--disable-multilib"
  ];

  preConfigure = ''
    mkdir ../../build
    cd ../../build
    configureScript=../$sourceRoot/configure
  '';

  hardeningDisable = [
    "fortify"
    # Because we are building it!
    "stackprotector"
  ];

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
