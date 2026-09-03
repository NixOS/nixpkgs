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

  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "zubanls";
    repo = "zuban";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M53A4SIimyVtNrRZLUMYpdCo9U+otw9aw8tN4QJSgc8=";
    fetchSubmodules = true;
  };

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/zuban
    cp -r third_party $out/${python3.sitePackages}/zuban/
  '';

  buildAndTestSubdir = "crates/zuban";

  cargoHash = "sha256-e16nmdATpPDBkGv+r5wmdNBbOXMXn/xPs3pmTbWMqKA=";

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
