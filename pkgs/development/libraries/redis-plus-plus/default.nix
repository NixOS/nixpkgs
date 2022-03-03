{ lib, stdenv, fetchFromGitHub, cmake, hiredis
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic
}:

# You must build at one type of library
assert enableShared || enableStatic;

stdenv.mkDerivation rec {
  pname = "redis-plus-plus";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "sewenew";
    repo = "redis-plus-plus";
    rev = version;
    sha256 = "sha256-k4q5YbbbKKHXcL0nndzJPshzXS20ARz4Tdy5cBg7kMc=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ hiredis ];

  cmakeFlags = [
    "-DREDIS_PLUS_PLUS_BUILD_TEST=OFF"
  ] ++ lib.optional (!enableShared) [
    "-DREDIS_PLUS_PLUS_BUILD_SHARED=OFF"
  ] ++ lib.optional (!enableStatic) [
    "-DREDIS_PLUS_PLUS_BUILD_STATIC=OFF"
  ];

  meta = with lib; {
    homepage = "https://github.com/sewenew/redis-plus-plus";
    description = "Redis client written in C++";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wheelsandmetal ];
  };
}
