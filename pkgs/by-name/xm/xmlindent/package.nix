{
  lib,
  stdenv,
  fetchFromGitHub,
  flex,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmlindent";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "penberg";
    repo = "xmlindent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cYMHgi1TqMBzt/jqwPgwwFwE1UWvg8LaaKDvgAVg5Uo=";
  };

  buildInputs = [ flex ];

  preConfigure = ''
    substituteInPlace Makefile --replace-fail "PREFIX=/usr/local" "PREFIX=$out"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "XML stream reformatter";
    mainProgram = "xmlindent";
    homepage = "https://xmlindent.sourceforge.net/";
    changelog = "https://github.com/penberg/xmlindent/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
