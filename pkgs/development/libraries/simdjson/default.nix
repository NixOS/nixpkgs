{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "simdjson";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    rev = "v${version}";
    sha256 = "sha256-PU6yTA2FXHcuSwr6oIU+cP7uYxkgggnj3FV2LbkS69w=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSIMDJSON_DEVELOPER_MODE=OFF"
  ] ++ lib.optional stdenv.hostPlatform.isStatic "-DBUILD_SHARED_LIBS=OFF";

  meta = with lib; {
    homepage = "https://simdjson.org/";
    description = "Parsing gigabytes of JSON per second";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ chessai ];
  };
}
