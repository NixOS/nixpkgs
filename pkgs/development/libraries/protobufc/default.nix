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
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "refs/tags/v${version}";
    hash = "sha256-TJCLzxozuZ8ynrBQ2lKyk03N+QA/lbOwywUjDUdTlbM=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ protobuf zlib ];

  PROTOC = lib.getExe buildPackages.protobuf;

  meta = with lib; {
    homepage = "https://github.com/protobuf-c/protobuf-c/";
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nickcao ];
  };
}
