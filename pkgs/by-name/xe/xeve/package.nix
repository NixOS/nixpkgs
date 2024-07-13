{
  lib,
  fetchFromGitHub,
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

  postPatch = ''
    echo v$version > version.txt
  '';

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    ln $dev/include/xeve/* $dev/include/
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-lm" ];

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
    broken = !stdenv.hostPlatform.isx86;
  };
})
