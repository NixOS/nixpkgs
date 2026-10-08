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
  pname = "libquadmath";
  inherit version;

  src = runCommand "libquadmath-src-${version}" { src = monorepoSrc; } (
    ''
      runPhase unpackPhase

      mkdir -p "$out/gcc"
      cp gcc/BASE-VER "$out/gcc"
      cp gcc/DATESTAMP "$out/gcc"

      cp -r libquadmath "$out"

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

  sourceRoot = "${finalAttrs.src.name}/libquadmath";

  preConfigure = ''
    mkdir ../../build
    cd ../../build
    configureScript=../$sourceRoot/configure
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
