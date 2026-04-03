{
  bash,
  diffutils,
  dtc,
  fetchFromGitiles,
  lib,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "libufdt";
  version = "0-unstable-2026-04-02";

  src = fetchFromGitiles {
    url = "https://android.googlesource.com/platform/system/libufdt";
    rev = "30486c8b56ac46b2a368918f8851618488832caf"; # tracking main-kernel
    hash = "sha256-L5U/L1+ra20lZDsag4yNHKNGkovZg4MD8vrdkqB1pEU=";
  };

  # libufdt uses Android.bp files. The meson.build is derived from the Soong build files.
  preConfigure = ''
    cp ${./meson.build} meson.build
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ dtc ];

  postPatch = ''
    patchShebangs tests/
  '';

  doCheck = true;
  mesonCheckFlags = [ "--verbose" ];
  nativeCheckInputs = [
    dtc
    bash
    diffutils
  ];

  meta = {
    description = "Library and tools for manipulating Flattened Device Trees";
    homepage = "https://android.googlesource.com/platform/system/libufdt";
    license = lib.licenses.asl20;
    mainProgram = "ufdt_apply_overlay";
    maintainers = [ lib.maintainers.elliotberman ];
    platforms = lib.platforms.linux;
  };
}
