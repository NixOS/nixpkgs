{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  protobuf,
  zlib,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "protobuf-c";
  version = "unstable-2023-07-08";

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "fa86fddbd000316772d1deb5a8d1201fa7599ef7";
    hash = "sha256-pmqZYFREPgSrWPekymTglhtAv6gQR1gP3dOl3hqjYig=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    protobuf
    zlib
  ];

  env.PROTOC = lib.getExe buildPackages.protobuf;

  meta = with lib; {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nickcao ];
  };
}
