{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "websocket++";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "zaphoyd";
    repo = "websocketpp";
    rev = version;
    sha256 = "sha256-9fIwouthv2GcmBe/UPvV7Xn9P2o0Kmn2hCI4jCh0hPM=";
  };

  patches = [
    # Fix build with cmake4
    (fetchpatch {
      url = "https://github.com/zaphoyd/websocketpp/commit/deb0a334471362608958ce59a6b0bcd3e5b73c24.patch?full_index=1";
      hash = "sha256-bFCHwtRuCFz9vr4trmmBLziPSlEx6SNjsTcBv9zV8go=";
    })
    # Fix build with boost187/newer asio
    # https://github.com/zaphoyd/websocketpp/pull/1164
    ./websocketpp-0.8.2-boost-1.87-compat.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://www.zaphoyd.com/websocketpp/";
    description = "C++/Boost Asio based websocket client/server library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ revol-xut ];
  };
}
