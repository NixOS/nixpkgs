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
  pname = "libiberty";
  inherit version;

  src = runCommand "libiberty-src-${version}" { src = monorepoSrc; } ''
    runPhase unpackPhase

    mkdir -p "$out/gcc"
    cp gcc/BASE-VER "$out/gcc"
    cp gcc/DATESTAMP "$out/gcc"

    cp -r include "$out"
    cp -r libiberty "$out"

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

  enableParallelBuilding = true;

  sourceRoot = "${finalAttrs.src.name}/libiberty";

  preConfigure = ''
    mkdir ../../build
    cd ../../build
    configureScript=../$sourceRoot/configure
  '';

  configureFlags = [
    "--enable-install-libiberty"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isStatic) "--enable-shared";

  postInstall = ''
    cp pic/libiberty.a $out/lib/libiberty_pic.a
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
