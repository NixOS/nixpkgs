{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  vimcats,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vimcats";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lumen-oss";
    repo = "vimcats";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Pg6vIp/2H4YyqaGKF/pvuhsD/j3hBms/+4cAbH89oKs=";
  };

  buildFeatures = [ "cli" ];

  cargoHash = "sha256-EeCp1VFNFrlPmJnqthZoFBEzi4VV+U53lmXT0NmJWI8=";

  passthru.tests.version = testers.testVersion { package = vimcats; };

  meta = {
    description = "CLI to generate vim/nvim help doc from LuaCATS. Forked from lemmy-help";
    longDescription = ''
      `vimcats` is a LuaCATS parser as well as a CLI which takes that parsed tree and converts it into vim help docs.
      It is a fork of lemmy-help that aims to support more recent LuaCATS features.
    '';
    homepage = "https://github.com/lumen-oss/vimcats";
    changelog = "https://github.com/lumen-oss/vimcats/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ mrcjkb ];
    mainProgram = "vimcats";
  };
})
