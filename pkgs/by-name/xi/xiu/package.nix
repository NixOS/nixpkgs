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
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "harlanc";
    repo = "xiu";
    rev = "v${version}";
    hash = "sha256-JST8nxsT+w524VzNeIW38Oct/n7VJ/nvrmgks2Vff30=";
  };

  cargoHash = "sha256-te60gZdDmbgOF6rLDAnvDx6vUbmCz3pC/wbu/iXgxAw=";

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
    maintainers = with maintainers; [ marsam ];
    mainProgram = "xiu";
  };
}
