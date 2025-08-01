{
  rustPlatform,
  fetchFromGitHub,
  lib,
  acl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xcp";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = "xcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TI9lveFJsb/OgGQRiPW5iuatB8dsc7yxBs1rb148nEY=";
  };

  cargoHash = "sha256-9cNu0cgoo0/41daJwy/uWIXa2wFhYkcPhJfA/69DVx0=";

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
