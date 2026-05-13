{
  lib,
  stdenv,
  fetchFromGitHub,
}:

# Testing this requires a Thinkpad or the presence of /proc/acpi/ibm/fan
stdenv.mkDerivation (finalAttrs: {
  pname = "zcfan";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "zcfan";
    rev = finalAttrs.version;
    hash = "sha256-/q9jDqjG4g211CTb4ahagpxux2BsZWTEyoAY8kRRTB8=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local" $out
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/zcfan -h

    runHook postInstallCheck
  '';

  meta = {
    description = "Zero-configuration fan daemon for ThinkPads";
    mainProgram = "zcfan";
    homepage = "https://github.com/cdown/zcfan";
    changelog = "https://github.com/cdown/zcfan/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      kashw2
    ];
    platforms = lib.platforms.linux;
  };
})
