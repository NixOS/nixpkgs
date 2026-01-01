{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
<<<<<<< HEAD
  python3,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zuban";

<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-nNbrZI1L9sw0sBTg2H2+9K05eoVmIl4bF5o1ADRXGDM=";
    fetchSubmodules = true;
  };

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/zuban
    cp -r third_party $out/${python3.sitePackages}/zuban/
  '';

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-7SHXqWSfzEZo2BRY9S3LiVLRd9v8MuxdbgWC7KDfgJM=";
=======
    hash = "sha256-nSQf3I9O5TP1V8kwJrcBRREqS/47UlILx3IZMmt5ljQ=";
  };

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-Q09ZUBVa52fXIKiL6aC9VZB+4Rt/hI045CIjb/t3Xyg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mypy-compatible Python Language Server built in Rust";
    homepage = "https://zubanls.com";
    # There's no changelog file yet, but they post updates on their blog.
    changelog = "https://zubanls.com/blog/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
<<<<<<< HEAD
      bew
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mcjocobe
    ];
    platforms = lib.platforms.all;
    mainProgram = "zuban";
  };
})
