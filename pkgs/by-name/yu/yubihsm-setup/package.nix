{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  yubihsm-shell,
}:

rustPlatform.buildRustPackage (finalPackage: {
  pname = "yubihsm-setup";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsm-setup";
    tag = finalPackage.version;
    hash = "sha256-ScpcEDNWLhywtcPPG84vZyIAQ5lF07udmGsmsyc3+iU=";
  };

  yubihsmrs = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubihsmrs";
    tag = "2.1.4";
    hash = "sha256-MQwp2dkAkPNyclDgRhHWRHZ9y4LC+bGIeLBv8CgMGXY=";
  };

  prePatch = ''
    ln -s $yubihsmrs yubihsmrs
    substituteInPlace Cargo.toml --replace-fail ../yubihsmrs/ ./yubihsmrs/
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ yubihsm-shell ];

  # https://github.com/Yubico/yubihsm-setup/pull/20
  cargoPatches = [ ./cargo-lock.patch ];

  cargoHash = "sha256-Mk0uGNb0WGygSqocpo566sVHs13zvoFBbAevJj4OSBM=";

  meta = {
    description = "Tool to easily set up a YubiHSM device";
    homepage = "https://github.com/Yubico/yubihsm-setup";
    maintainers = with lib.maintainers; [
      numinit
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
