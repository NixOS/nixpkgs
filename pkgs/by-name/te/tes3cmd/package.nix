{
  lib,
  fetchFromGitHub,
  perl,
  stdenvNoCC,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tes3cmd";
  version = "0.40-pre-release-2";

  src = fetchFromGitHub {
    owner = "john-moonsugar";
    repo = "tes3cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ry05CAsdNkhlKSKOLiwcLhvz5wd2mEQKtR0sjy69+Ac=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    install -Dm755 tes3cmd -t $out/bin

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  preVersionCheck = ''
    version=${lib.toUpper finalAttrs.version}
  '';

  meta = {
    description = "Command line tool for examining and modifying plugins for the Elder Scrolls game Morrowind by Bethesda Softworks";
    homepage = "https://github.com/john-moonsugar/tes3cmd";
    changelog = "https://github.com/john-moonsugar/tes3cmd/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marius851000 ];
    platforms = lib.platforms.linux;
    mainProgram = "tes3cmd";
  };
})
