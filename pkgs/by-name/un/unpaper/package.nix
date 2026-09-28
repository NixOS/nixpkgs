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
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unpaper";
  version = "7.0.0";

  src = fetchurl {
    url = "https://www.flameeyes.eu/files/unpaper-${finalAttrs.version}.tar.xz";
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

  nativeCheckInputs = with python3Packages; [
    pytest
    pytest-xdist
    pillow
  ];

  doCheck = true;

  # Tests take quite a long time
  # Using pytest-xdist, we launch multiple workers
  # Restrict to max 6 to avoid having a large number of idlers
  preCheck = ''
    mesonCheckFlagsArray+=(--test-args "--numprocesses=auto --maxprocesses=6")
  '';

  passthru.tests = {
    inherit (nixosTests) paperless;
  };

  meta = {
    homepage = "https://www.flameeyes.eu/projects/unpaper";
    changelog = "https://github.com/unpaper/unpaper/blob/unpaper-${finalAttrs.version}/NEWS";
    description = "Post-processing tool for scanned sheets of paper";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "unpaper";
    maintainers = [ lib.maintainers.rycee ];
  };
})
