{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  xxd,
  openssl,
  libwebsockets,
  json_c,
  libuv,
  zlib,
  nixosTests,
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "ttyd";
  version = "1.7.7";
  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = "ttyd";
    tag = version;
    sha256 = "sha256-7e08oBKU7BMZ8328qCfNynCSe7LVZ88+iQZRRKl2YkY=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    xxd
  ];
  buildInputs = [
    openssl
    libwebsockets
    json_c
    libuv
    zlib
  ];

  outputs = [
    "out"
    "man"
  ];

  passthru.tests = {
    inherit (nixosTests) ttyd;
  };

  meta = {
    description = "Share your terminal over the web";
    homepage = "https://github.com/tsl0922/ttyd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.thoughtpolice ];
    platforms = lib.platforms.all;
    mainProgram = "ttyd";
  };
}
