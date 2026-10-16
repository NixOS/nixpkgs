{
  lib,
  cmake,
  fetchFromGitHub,
  libopus,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xiu";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "harlanc";
    repo = "xiu";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gaYXyPwiT0R6ssUWs6VPpqk39QR/gzEVROSk0UpTquY=";
  };

  cargoHash = "sha256-hJV78hHptCAu7A8A0qCvwhPOIcxjffowrtJDjKHJ588=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libopus
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = 1;

  meta = {
    description = "Simple, high performance and secure live media server in pure Rust (RTMP[cluster]/RTSP/WebRTC[whip/whep]/HTTP-FLV/HLS";
    homepage = "https://github.com/harlanc/xiu";
    changelog = "https://github.com/harlanc/xiu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cafkafk ];
    mainProgram = "xiu";
  };
})
