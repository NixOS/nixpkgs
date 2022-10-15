{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "simdjson";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    rev = "v${version}";
    sha256 = "sha256-Ub0gHxnc4ljVqbAWuFJYBuhA4FjX4ypg1gaPXUrcWkE=";
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
