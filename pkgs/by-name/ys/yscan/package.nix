{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yscan";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "yetidevworks";
    repo = "yscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dIRtqn6vismwgQUwfK5KzApBDBlAmOt+mfdBY8sr47g=";
  };

  __structuredAttrs = true;

  cargoPatches = [
    # https://github.com/yetidevworks/yscan/pull/2
    (fetchpatch2 {
      name = "cargo-lock.patch";
      url = "https://github.com/yetidevworks/yscan/commit/54c0d9f008e0a9205ff639db8223c0a89fe72f34.patch?full_index=1";
      hash = "sha256-n1JthKGLAS+Rx4BiLNwtRNZ4NHpS0Azv6uThjQgWqJg=";
    })
  ];

  cargoHash = "sha256-nQV0vtx2hwKxysSHNB6j9d6JSuFlFFqtZr2hPciyo40=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  meta = {
    description = "TUI IP and Port Scanner";
    homepage = "https://github.com/yetidevworks/yscan";
    changelog = "https://github.com/yetidevworks/yscan/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yscan";
  };
})
