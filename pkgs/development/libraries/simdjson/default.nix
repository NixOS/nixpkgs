{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "simdjson";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    rev = "v${version}";
    sha256 = "0lpb8la74xwd78d5mgwnzx4fy632jbmh0ip19v0dydwm0kagm0a3";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSIMDJSON_JUST_LIBRARY=ON"
  ] ++ lib.optional stdenv.hostPlatform.isStatic "-DSIMDJSON_BUILD_STATIC=ON";

  meta = with lib; {
    homepage = "https://simdjson.org/";
    description = "Parsing gigabytes of JSON per second";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ chessai ];
  };
}
