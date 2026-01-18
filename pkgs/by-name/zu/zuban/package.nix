{
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  python3,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zuban";

  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3K2PHccGXLD4Jk+DhSoD8dbOG+n40tbiAPfEF27vukg=";
    fetchSubmodules = true;
  };

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/zuban
    cp -r third_party $out/${python3.sitePackages}/zuban/
  '';

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-2TlCwbGabJtIusfRVWSnQiZbv6UQIBXfcUBVQrrepYM=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

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
      bew
      mcjocobe
    ];
    platforms = lib.platforms.all;
    mainProgram = "zuban";
  };
})
