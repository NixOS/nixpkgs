{
  rustPlatform,
  fetchFromGitHub,
  lib,
  acl,
  nix-update-script,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xcp";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ojk2khNLKhnAbWlBG2QEhcVrXz5wuC92IOEG3o58E3A=";
  };

  cargoHash = "sha256-uJVm9nxXXfn4ZEIYoX2XMhZN7Oduwi1D8wZmv64mx60=";

  nativeBuildInputs = [ installShellFiles ];

  checkInputs = [ acl ];

  # disable tests depending on special filesystem features
  checkNoDefaultFeatures = true;
  checkFeatures = [
    "test_no_reflink"
    "test_no_sparse"
    "test_no_extents"
    "test_no_acl"
    "test_no_xattr"
    "test_no_perms"
  ];

  postInstall = ''
    installShellCompletion --cmd xcp \
      --bash completions/xcp.bash \
      --fish completions/xcp.fish \
      --zsh completions/xcp.zsh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    changelog = "https://github.com/tarka/xcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lom ];
    mainProgram = "xcp";
  };
})
