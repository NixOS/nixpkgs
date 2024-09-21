{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, protobuf
, zlib
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "protobuf-c";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "refs/tags/v${version}";
    hash = "sha256-Dkpcc7ZfvAIVY91trRiHuiRFcUGUbQxbheYKTBcq80I=";
  };

  patches = [
    # https://github.com/protobuf-c/protobuf-c/issues/709
    # https://github.com/protobuf-c/protobuf-c/pull/711
    ./recent_protobuf_compat.patch
  ];

  outputs = [ "out" "dev" "lib" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ protobuf zlib ];

  env.PROTOC = lib.getExe buildPackages.protobuf;

  meta = with lib; {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nickcao ];
  };
}
