{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zuban";

  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9Am71HLJgApieZccoL9am7m8408frleQ/7+U4xrVlGI=";
    fetchSubmodules = true;
  };

  postInstall = ''
    mkdir -p $out/lib/zuban
    cp -r typeshed $out/lib/zuban/
    wrapProgram $out/bin/zuban \
      --set ZUBAN_TYPESHED $out/lib/zuban/typeshed
  '';

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-RIfAfOecIUrAemgE74bNRJ63dztbNctQR7mJLS/zwSE=";

  nativeBuildInputs = [
    makeWrapper
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
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
      mcjocobe
    ];
    platforms = lib.platforms.all;
    mainProgram = "zuban";
  };
})
