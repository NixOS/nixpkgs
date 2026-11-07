{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  nodejs-slim,
  clang_20,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "vsce";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PYNsLQlSjXKulqME7K5UVOBbp2R+BioM3+Kf3v/MSZ4=";
  };

  npmDepsHash = "sha256-+hqJrXScrQfh+zgVASZbvunoR9K67jjfRLFrfBnbR5o=";

  postPatch = ''
    substituteInPlace package.json --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'
  '';

  nativeBuildInputs = [
    pkg-config
    nodejs-slim.python
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ clang_20 ]; # clang_21 breaks @vscode/vsce's optional dependency keytar

  buildInputs = [ libsecret ];

  makeCacheWritable = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
