{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  nodejs,
  clang_20,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "vsce";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dNSO+PoUNQUtvS6NZJ/InOYqI4vav+WNg6kCA+CaWL8=";
  };

  npmDepsHash = "sha256-rqwb1bz/OFHzL8GgqMZtuqYkeST5qlFybDRSFOx7LtU=";

  postPatch = ''
    substituteInPlace package.json --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    nodejs.python
  ]
  ++ lib.optionals stdenv.isDarwin [ clang_20 ]; # clang_21 breaks @vscode/vsce's optional dependency keytar

  buildInputs = [ libsecret ];

  makeCacheWritable = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/microsoft/vscode-vsce";
    description = "Visual Studio Code Extension Manager";
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    license = lib.licenses.mit;
    mainProgram = "vsce";
  };
})
