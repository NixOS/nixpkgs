{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "testlib";
  version = "0.9.41-unstable-2026-02-06";

  src = fetchFromGitHub {
    owner = "MikeMirzayanov";
    repo = "testlib";
    rev = "1e4e8a24c79c6bad3becbdb5a332ffc352b7d5dd";
    hash = "sha256-+gTiv/3glv5KfT6Hitcuh7uReSvI2j0ii1Ufr1vGfms=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 testlib.h $out/include/testlib.h
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=master" ];
  };

  meta = {
    description = "C++ library to develop competitive programming problems";
    homepage = "https://github.com/MikeMirzayanov/testlib";
    changelog = "https://github.com/MikeMirzayanov/testlib/compare/0.9.41...${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.all;
  };
})
