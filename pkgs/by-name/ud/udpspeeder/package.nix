{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udpspeeder";
  version = "20230206.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = "UDPspeeder";
    tag = finalAttrs.version;
    hash = "sha256-hrwkPSxY1DTEXt9vxDECDEJaoTDzBUS7rVI609uZwdU=";
  };

  preBuild = ''
    echo "const char *gitversion = \"${finalAttrs.version}\";" > git_version.h # From Makefile
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$PWD"
  '';

  nativeBuildInputs = [
    cmake
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./speederv2 $out/bin/speederv2

    runHook postInstall
  '';

  nativeCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/wangyu-/UDPspeeder";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
    changelog = "https://github.com/wangyu-/UDPspeeder/releases/tag/${finalAttrs.version}";
    description = "Tunnel which Improves your Network Quality on a High-latency Lossy Link by using Forward Error Correction, possible for All Traffics(TCP/UDP/ICMP)";
    mainProgram = "speederv2";
  };
})
