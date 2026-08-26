{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  weechat,
  openssl,
  sqlite,
  runCommand,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weechat-matrix-rs";
  version = "0-unstable-2026-07-16";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = "weechat-matrix-rs";
    rev = "f987e71a46827b8e69112cfb8e5977cf59fc313a";
    hash = "sha256-Uew4rUKB9kRSE6SdswkFdjl/aumUflYf2+8WPSlg5sE=";
  };

  cargoHash = "sha256-Km6wZ2SVIAMD4WV3BHof3WouD+kxR7LKtpknu0g9Qh4=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    weechat
    openssl
    sqlite
  ];

  postInstall = ''
    mkdir -p $out/lib/weechat/plugins
    mv $out/lib/libmatrix${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/weechat/plugins/matrix${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  passthru.tests.load-plugin =
    runCommand "${finalAttrs.pname}-test-load"
      {
        nativeBuildInputs = [ weechat ];
      }
      ''
        weechat -t -d "$(mktemp -d)" \
         --run-command "/plugin load ${finalAttrs.finalPackage}/lib/weechat/plugins/matrix${stdenv.hostPlatform.extensions.sharedLibrary} ; /quit" \
         2>&1 | tee log
        if grep -q 'Plugin "matrix" loaded' log; then
          echo "Check passed: matrix plugin loaded into WeeChat."
          touch $out
        else
          echo "Check failed: 'matrix' not found in WeeChat output."
          exit 1
        fi
      '';

  meta = {
    description = "Rust plugin for WeeChat to communicate over Matrix";
    homepage = "https://github.com/poljar/weechat-matrix-rs";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ zodman ];
    platforms = lib.platforms.unix;
  };

})
