{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  stdenv,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeve";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xeve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8jXntm/yFme9ZPImdW54jAr11hEsU1K+N5/7RLmITPs=";
  };

  patches = lib.optionals (!lib.versionOlder "0.5.0" finalAttrs.version) [
    (fetchpatch2 {
      url = "https://github.com/mpeg5/xeve/commit/954ed6e0494cd2438fd15c717c0146e88e582b33.patch?full_index=1";
      hash = "sha256-//NtOUm1fqPFvOM955N6gF+QgmOdmuVunwx/3s/G/J8=";
    })
  ];

  postPatch = ''
    echo v$version > version.txt
  '';

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    ln $dev/include/xeve/* $dev/include/
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/mpeg5/xeve";
    description = "eXtra-fast Essential Video Encoder, MPEG-5 EVC";
    license = lib.licenses.bsd3;
    mainProgram = "xeve_app";
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
    # Currently only supports gcc and msvc as compiler, the limitation for clang gets removed in the next release, but that does not fix building on darwin.
    broken = !stdenv.hostPlatform.isx86 || !stdenv.cc.isGNU;
  };
})
