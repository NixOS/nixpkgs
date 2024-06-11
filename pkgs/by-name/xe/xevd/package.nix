{
  lib,
  fetchFromGitHub,
  stdenv,
  gitUpdater,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xevd";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xevd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dc2V77t+DrZo9252FAL0eczrmikrseU02ob2RLBdVvU=";
  };

  postPatch = ''
    echo v$version > version.txt
  '';

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    ln $dev/include/xevd/* $dev/include/
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/mpeg5/xevd";
    description = "eXtra-fast Essential Video Decoder, MPEG-5 EVC";
    license = lib.licenses.bsd3;
    mainProgram = "xevd_app";
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
    broken = !stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isDarwin;
  };
})
