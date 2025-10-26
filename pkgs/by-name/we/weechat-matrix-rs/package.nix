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
  version = "0-unstable-2025-10-09";
  src = fetchFromGitHub {
    owner = "poljar";
    repo = "weechat-matrix-rs";
    rev = "4cc5777b630ba4d6a9c964248531f283178a4717";
    hash = "sha256-CF4xDoRYey9F8/XSW/euNb8IjZXyP6k0Nj61shsmyEo=";
  };
  cargoHash = "sha256-jAlBCmLJfWWAUHd3ySB930iqAVXMh6ueba7xS///Rt0=";
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
