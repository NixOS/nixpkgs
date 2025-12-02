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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libatomic";
  inherit version;

  src = runCommand "libatomic-src-${version}" { src = monorepoSrc; } ''
    runPhase unpackPhase

    mkdir -p "$out/gcc"
    cp gcc/BASE-VER "$out/gcc"
    cp gcc/DATESTAMP "$out/gcc"

    cp -r libatomic "$out"

    cp -r config "$out"
    cp -r multilib.am "$out"
    cp -r libtool.m4 "$out"

    cp config.guess "$out"
    cp config.rpath "$out"
    cp config.sub "$out"
    cp config-ml.in "$out"
    cp ltmain.sh "$out"
    cp install-sh "$out"
    cp mkinstalldirs "$out"

    [[ -f MD5SUMS ]]; cp MD5SUMS "$out"
  '';

  patches = [
    (fetchpatch {
      name = "custom-threading-model.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250716204545.1063669-1-git@JohnEricson.me/raw";
      hash = "sha256-kxNntY2r4i/+XHQSpf9bYV2Jg+FD/pD5TiMn5hd4ckk=";
      includes = [
        "config/*"
        "libatomic/*"
      ];
    })
  ];

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  preAutoreconf = ''
    sourceRoot=$(readlink -e "./libatomic")
    cd $sourceRoot
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook269
  ];

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--disable-dependency-tracking"
    "cross_compiling=true"
    "--disable-multilib"
  ];

  preConfigure = ''
    cd "$buildRoot"
    configureScript=$sourceRoot/configure
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
