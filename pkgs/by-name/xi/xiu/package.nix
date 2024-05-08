{ lib
, cmake
, darwin
, fetchFromGitHub
, libopus
, openssl
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "xiu";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "harlanc";
    repo = "xiu";
    rev = "v${version}";
    hash = "sha256-53fVb5c9uS92/rPvZDWXxZX42p4cHqumGe6Dw+/hLvk=";
  };

  cargoHash = "sha256-ICZQ+UJ4LPNSeT9SjdcCUXgam40hMAOrJmLIwPEfqs4=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libopus
  ] ++ lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A simple, high performance and secure live media server in pure Rust (RTMP[cluster]/RTSP/WebRTC[whip/whep]/HTTP-FLV/HLS";
    homepage = "https://github.com/harlanc/xiu";
    changelog = "https://github.com/harlanc/xiu/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "xiu";
  };
}
