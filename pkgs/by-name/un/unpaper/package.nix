{
  lib,
  stdenv,
  fetchurl,

  # build
  meson,
  ninja,
  pkg-config,

  # docs
  sphinx,

  # runtime
  buildPackages,
  ffmpeg-headless,

  # tests
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "unpaper";
  version = "7.0.0";

  src = fetchurl {
    url = "https://www.flameeyes.eu/files/${pname}-${version}.tar.xz";
    hash = "sha256-JXX7vybCJxnRy4grWWAsmQDH90cRisEwiD9jQZvkaoA=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    buildPackages.libxslt.bin
    meson
    ninja
    pkg-config
    sphinx
  ];

  buildInputs = [
    ffmpeg-headless
  ];

  passthru.tests = {
    inherit (nixosTests) paperless;
  };

  meta = {
    homepage = "https://www.flameeyes.eu/projects/unpaper";
    changelog = "https://github.com/unpaper/unpaper/blob/unpaper-${version}/NEWS";
    description = "Post-processing tool for scanned sheets of paper";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "unpaper";
    maintainers = [ lib.maintainers.rycee ];
  };
}
