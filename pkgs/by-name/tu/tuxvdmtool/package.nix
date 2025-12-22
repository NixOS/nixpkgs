{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "tuxvdmtool";
  version = "0-unstable-2025-09-18";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "tuxvdmtool";
    rev = "0ea08c2b70304497a880545017e354915e4acd3c";
    hash = "sha256-AmiiA6dr4k/CUNPCCDdOdWiS/g2FywPFF75JqYcCP0U=";
  };

  # https://github.com/AsahiLinux/tuxvdmtool/issues/2
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Apple Silicon to Apple Silicon VDM utility";
    homepage = "https://github.com/AsahiLinux/tuxvdmtool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tuxvdmtool";
    platforms = lib.platforms.linux;
  };
}
