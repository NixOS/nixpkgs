{
  lib,
  fetchFromGitHub,
  stdenv,
  gitUpdater,
  testers,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vvenc";
  version = "1.13.0-rc1";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "fraunhoferhhi";
    repo = "vvenc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y6t3x5F5olQf2tgfg08dMsBEG+ndgGveRyBQQACZmn0=";
  };

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      "-Wno-maybe-uninitialized"
      "-Wno-uninitialized"
    ]
  );

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "VVENC_INSTALL_FULLFEATURE_APP" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://github.com/fraunhoferhhi/vvenc";
    description = "Fraunhofer Versatile Video Encoder";
    license = lib.licenses.bsd3Clear;
    mainProgram = "vvencapp";
    pkgConfigModules = [ "libvvenc" ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
  };
})
