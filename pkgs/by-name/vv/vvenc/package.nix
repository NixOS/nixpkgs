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
  version = "1.12.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "fraunhoferhhi";
    repo = "vvenc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C7ApayhubunkXBqJ/EqntaFPn6zk8rZ9fUqg7kbhvAk=";
  };

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
