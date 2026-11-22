{
  fetchFromCodeberg,
  lib,
  stdenv,
  versionCheckHook,
  nix-update-script,
  runCommand,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "within";
  version = "1.1.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "sjmulder";
    repo = "within";
    tag = finalAttrs.version;
    hash = "sha256-UyOgEe07K1LW5IbB7ngxelp+9Njq/NPPkWw3sxAQyVY=";
  };

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  preVersionCheck = ''
    versionCheckProgram=$(type -P echo)
    versionCheckProgramArg=$(head -n 1 CHANGELOG.md)
  '';

  dontVersionCheck = lib.hasInfix "unstable" finalAttrs.version;

  installFlags = [ "PREFIX:=$(out)" ];

  passthru = {
    tests.within =
      runCommand "within-test"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          mkdir $out
          result=$(within $PWD $out - pwd)
          expected=$(printf '%s\n' "$PWD: $PWD" "$out: $out")
          test "$result" = "$expected"
        '';

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://codeberg.org/sjmulder/within";
    description = "Run a command in other directories";
    changelog = "https://codeberg.org/sjmulder/within/src/tag/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.examosa ];
    platforms = lib.platforms.all;
    mainProgram = "within";
  };
})
