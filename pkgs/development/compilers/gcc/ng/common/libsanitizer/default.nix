{
  lib,
  stdenv,
  libstdcxx,
  gcc_meta,
  release_version,
  version,
  monorepoSrc ? null,
  fetchpatch,
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

  # This component's share of Iain Sandoe's Darwin branch, taken from Homebrew
  # as the monolithic set takes it. One `configure.tgt` case; `gcc` and
  # `libgcc` take their own parts of the same diff.
  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    (fetchpatch {
      name = "darwin-aarch64-support.patch";
      url =
        if lib.versionAtLeast release_version "16" then
          "https://raw.githubusercontent.com/Homebrew/homebrew-core/70e2a9e1d072fa3bc34cf41d97f4b65bede2b01e/Patches/gcc/gcc-16.1.0.diff"
        else
          "https://raw.githubusercontent.com/Homebrew/homebrew-core/70e2a9e1d072fa3bc34cf41d97f4b65bede2b01e/Patches/gcc/gcc-15.3.0.diff";
      includes = [ "libsanitizer/*" ];
      hash =
        if lib.versionAtLeast release_version "16" then
          "sha256-NvDEjWfD2eEPJWtWOjtMeymdADPx9rm7Sn+6iGQg5EI="
        else
          "sha256-UF2p8qg7M6e4gsSC3TIyyE8+F+tPJUjiGF30fW53XeM=";
    })
  ];

  # `sourceRoot` above puts `patchPhase` inside `libsanitizer`, but the patch
  # names its files from the top of the monorepo.
  patchFlags = [ "-p2" ];

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
