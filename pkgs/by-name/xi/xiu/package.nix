{
  lib,
  cmake,
  darwin,
  fetchFromGitHub,
  libopus,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "xiu";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "harlanc";
    repo = "xiu";
    rev = "v${version}";
    hash = "sha256-EjyvCwqcPkOe69YnDiAExtBNPhsqqGa95ao+bn6wcyA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IEIZM27zQZrq63ZsCVAeOl2exuFR5tUG3Gwipjg4+oo=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      libopus
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Simple, high performance and secure live media server in pure Rust (RTMP[cluster]/RTSP/WebRTC[whip/whep]/HTTP-FLV/HLS";
    homepage = "https://github.com/harlanc/xiu";
    changelog = "https://github.com/harlanc/xiu/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "xiu";
  };
}
