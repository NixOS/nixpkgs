{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "testlib";
  version = "0.9.41";

  src = fetchFromGitHub {
    owner = "MikeMirzayanov";
    repo = "testlib";
    tag = finalAttrs.version;
    hash = "sha256-AttzDYLDlpfL3Zvds6yBR/m6W/3UZKR+1LVylqOTQcw=";
  };

  installPhase = ''
    runHook preInstall
    install -Dt $out/include/testlib testlib.h
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ library to develop competitive programming problems";
    homepage = "https://github.com/MikeMirzayanov/testlib";
    changelog = "https://github.com/MikeMirzayanov/testlib/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.all;
  };
})
