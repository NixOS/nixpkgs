{
  lib,
  stdenv,
  libstdcxx,
  gcc_meta,
  release_version,
  version,
  monorepoSrc ? null,
  runCommand,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libsanitizer";
  inherit version;

  src = runCommand "libsanitizer-src-${version}" { src = monorepoSrc; } (
    ''
      runPhase unpackPhase

      mkdir -p "$out/gcc"
      cp gcc/BASE-VER "$out/gcc"
      cp gcc/DATESTAMP "$out/gcc"

      cp -r libsanitizer "$out"

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

  sourceRoot = "${finalAttrs.src.name}/libsanitizer";

  postUnpack = ''
    mkdir -p libstdc++-v3/src/
    ln -s ${libstdcxx}/lib/libstdc++.la libstdc++-v3/src/libstdc++.la
  '';

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
