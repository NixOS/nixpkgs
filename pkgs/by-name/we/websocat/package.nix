{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
  fetchpatch,
  libiconv,
  makeWrapper,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "websocat";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "vi";
    repo = "websocat";
    tag = "v${version}";
    hash = "sha256-v5+9cbKe3c12/SrW7mgN6tvQIiAuweqvMIl46Ce9f2A=";
  };

  # Fix build with Rust 1.87
  # FIXME: remove in next update
  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/vi/websocat/commit/d4455623e777231d69b029d69d7a17c0de2bafe7.diff";
      hash = "sha256-OUQQ+3eESE3XcGgToErqvF8ItpT8YCMAZhbvRzkFKpc=";
    })
  ];

  cargoHash = "sha256-3m7Gg//vjNjYlesEjKsdqjU48dAtgSeugxingr8OJyY=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  buildFeatures = [ "ssl" ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  # The wrapping is required so that the "sh-c" option of websocat works even
  # if sh is not in the PATH (as can happen, for instance, when websocat is
  # started as a systemd service).
  postInstall = ''
    wrapProgram $out/bin/websocat \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  doInstallCheck = true;

  meta = {
    description = "Command-line client for WebSockets (like netcat/socat)";
    homepage = "https://github.com/vi/websocat";
    changelog = "https://github.com/vi/websocat/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      thoughtpolice
    ];
    mainProgram = "websocat";
  };
}
