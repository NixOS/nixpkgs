{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  boringssl,
  cacert,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "trusttunnel-endpoint";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TrustTunnel";
    repo = "TrustTunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4cItVXJNGSFihHXWMpLKx/qJABwLZCvlJYGw2nM9SHY=";
  };

  cargoPatches = [
    # Bump boring to v5 (and by necessity, quiche to 0.30) for compatibility
    # with recent boringssl versions, which have removed curves that were
    # considered insufficiently secure.
    # Upstream PR: https://github.com/TrustTunnel/TrustTunnel/pull/155
    ./boring-v5.patch
  ];

  cargoHash = "sha256-wZbyro1ozP+h/o8MocgI8FxeJHfEzessWfNObfc4CEg=";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/boring-sys-*/build/main.rs $cargoDepsCopy/*/quiche-*/src/build.rs \
      --replace-fail "cargo:rustc-link-lib=static=crypto" "cargo:rustc-link-lib=dylib=crypto" \
      --replace-fail "cargo:rustc-link-lib=static=ssl" "cargo:rustc-link-lib=dylib=ssl"
  '';

  env = {
    BORING_BSSL_PATH = boringssl;
    BORING_BSSL_INCLUDE_PATH = "${boringssl.dev}/include";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    boringssl
  ];

  nativeCheckInputs = [
    cacert
    python3
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, fast and obfuscated VPN protocol - endpoint component";
    homepage = "https://github.com/TrustTunnel/TrustTunnel";
    changelog = "https://github.com/TrustTunnel/TrustTunnel/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "trusttunnel_endpoint";
  };
})
