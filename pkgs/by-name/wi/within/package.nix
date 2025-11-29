{
  fetchFromGitHub,
  lib,
  stdenv,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "within";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "sjmulder";
    repo = "within";
    tag = finalAttrs.version;
    hash = "sha256-UyOgEe07K1LW5IbB7ngxelp+9Njq/NPPkWw3sxAQyVY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  preVersionCheck = ''
    versionCheckProgram=$(type -P echo)
    versionCheckProgramArg=$(head -n 1 CHANGELOG.md)
  '';

  dontVersionCheck = lib.hasInfix "unstable" finalAttrs.version;

  meta = {
    homepage = "https://github.com/sjmulder/within";
    description = "Run a command in other directories";
    changelog = "https://github.com/sjmulder/within/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.examosa ];
    platforms = lib.platforms.all;
    mainProgram = "within";
  };
})
