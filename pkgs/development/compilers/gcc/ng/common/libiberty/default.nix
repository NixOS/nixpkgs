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

  src = runCommand "libiberty-src-${version}" { src = monorepoSrc; } (
    ''
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

    ''
    # `MD5SUMS` exists only in release tarballs, not in a VCS checkout.
    + ''
      if [[ -f MD5SUMS ]]; then cp MD5SUMS "$out"; fi
    ''
  );

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  sourceRoot = finalAttrs.src.name;

  # Match the split driver's response-origin and explicit scratch API, as well
  # as collect2's response-file writer. Patch from the shared source root so
  # include/libiberty.h and the implementation stay together.
  patches =
    lib.optionals stdenv.hostPlatform.isUnix [
      ../../../common/libiberty-primary-query.patch
    ]
    ++ lib.optional (lib.versionAtLeast release_version "14") (
      ../../../common/libiberty-writeargv-newlines.patch
    );

  preConfigure = ''
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/libiberty/configure
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
