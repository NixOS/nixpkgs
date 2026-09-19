{
  bash,
  diffutils,
  dtc,
  fetchFromGitiles,
  lib,
  meson,
  ninja,
  pkg-config,
  python3,
  stdenv,
  unstableGitUpdater,
}:
let
  url = "https://android.googlesource.com/platform/system/libufdt";
in
stdenv.mkDerivation {
  pname = "libufdt";
  version = "0-unstable-2026-05-14";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitiles {
    inherit url;
    rev = "be62b37978e6cf0ab5115701ec4afeaa463e7533";
    hash = "sha256-kWD3U5BLCFnPQpjn5aYPklrAbBtyIWXQWZcvyVvZef8=";
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
  buildInputs = [
    dtc
    python3
  ];

  postPatch = ''
    patchShebangs tests/ utils/src/mkdtboimg.py
  '';

  doCheck = true;
  mesonCheckFlags = [ "--verbose" ];
  nativeCheckInputs = [
    dtc
    bash
    diffutils
  ];

  passthru.updateScript = unstableGitUpdater {
    inherit url;
    branch = "main-kernel";
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Library and tools for manipulating Flattened Device Trees";
    homepage = "https://android.googlesource.com/platform/system/libufdt";
    license = lib.licenses.asl20;
    mainProgram = "ufdt_apply_overlay";
    maintainers = [ lib.maintainers.elliotberman ];
    platforms = lib.platforms.linux;
  };
}
