{
  lib,
  argp-standalone,
  callPackage,
  curl,
  fetchFromGitHub,
  gitUpdater,
  meson,
  ninja,
  pkg-config,
  stdenv,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zchunk";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "zchunk";
    repo = "zchunk";
    rev = finalAttrs.version;
    hash = "sha256-TE3qNXHm6s1N7F1Rm2CcWFkyz6nywJktKJ3GL0tf2t8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ argp-standalone ];

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  strictDeps = true;

  passthru = {
    updateScript = gitUpdater { };
    tests = lib.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./tests;
    };
  };

  meta = {
    homepage = "https://github.com/zchunk/zchunk";
    description = "File format designed for highly efficient deltas while maintaining good compression";
    longDescription = ''
      zchunk is a compressed file format that splits the file into independent
      chunks. This allows you to only download changed chunks when downloading a
      new version of the file, and also makes zchunk files efficient over rsync.

      zchunk files are protected with strong checksums to verify that the file
      you downloaded is, in fact, the file you wanted.
    '';
    license = lib.licenses.bsd2;
    mainProgram = "zck";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
