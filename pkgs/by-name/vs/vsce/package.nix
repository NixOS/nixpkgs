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
<<<<<<< HEAD
  version = "3.7.1";
=======
  version = "3.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-vsce";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-7Urn3MlcvJragFvbPYOurUCIOyqYQsEqg5IKbFwcHBo=";
  };

  npmDepsHash = "sha256-lJDCeOqSYZCI9o9RsFSviQKkxgcv8XGps3ecy55r7E4=";
=======
    hash = "sha256-dNSO+PoUNQUtvS6NZJ/InOYqI4vav+WNg6kCA+CaWL8=";
  };

  npmDepsHash = "sha256-rqwb1bz/OFHzL8GgqMZtuqYkeST5qlFybDRSFOx7LtU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
