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
  version = "0.0.23";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "uvwasi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+vz/qTMRRDHV1VE4nny9vYYtarZHk1xoM4EZiah3jnY=";
  };

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
