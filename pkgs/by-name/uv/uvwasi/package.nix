{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  libuv,
  nix-update-script,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uvwasi";
  version = "0.0.21";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "uvwasi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-po2Pwqf97JXGKY8WysvyR1vSkqQ4XIF0VQG+83yV9nM=";
  };

  # Patch was sent upstream: https://github.com/nodejs/uvwasi/pull/302.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'DESTINATION ''${CMAKE_INSTALL_INCLUDEDIR}/uvwasi' 'DESTINATION ''${CMAKE_INSTALL_INCLUDEDIR}'
  '';

  outputs = [
    "out"
  ];

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    libuv
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "uvwasi" ];
    };
  };

  meta = {
    description = "WASI syscall API built atop libuv";
    homepage = "https://github.com/nodejs/uvwasi";
    changelog = "https://github.com/nodejs/uvwasi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
  };
})
