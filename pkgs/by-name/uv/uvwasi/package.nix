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

  patches = [
    # This patch can be removed once it's included in a release.
    (fetchpatch2 {
        url = "https://github.com/nodejs/uvwasi/commit/e84496dd9b0c31a0d5025051ffdd71da69e641ed.patch?full_index=1";
        hash = "sha256-WQriIgcIXkhb9i/Sk9tw2pQ1eB5lkcHBmLYmoCqoc/s=";
    })
  ];

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
