{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  libuv,
  nix-update-script,
  stdenv,
  testers,
  validatePkgConfig,
  static ? stdenv.hostPlatform.isStatic, # generates static libraries *only*
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

  patches = [
    # FIXME: remove when included in a release
    (fetchpatch2 {
      url = "https://github.com/nodejs/uvwasi/commit/0820128569533c855d60c0f6382acbb14aa62ad2.patch?full_index=1";
      hash = "sha256-psjivoarqisOuCdVJAWuFH0aITzwb/obmal3ewVXvG4=";
    })
  ];
  postPatch = lib.optionalString static ''
    substituteInPlace CMakeLists.txt --replace-fail 'TARGETS uvwasi_a uvwasi' 'TARGETS uvwasi_a'
  '';
  cmakeFlags = [
    (lib.cmakeBool "UVWASI_BUILD_SHARED" (!static))
  ];

  outputs = [
    "out"
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];
  buildInputs = [
    libuv
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "WASI syscall API built atop libuv";
    homepage = "https://github.com/nodejs/uvwasi";
    changelog = "https://github.com/nodejs/uvwasi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "uvwasi" ];
  };
})
