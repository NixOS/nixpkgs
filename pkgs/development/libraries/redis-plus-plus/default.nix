{ lib, stdenv, fetchFromGitHub, cmake, hiredis, libuv
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic
}:

# You must build at one type of library
assert enableShared || enableStatic;

stdenv.mkDerivation rec {
  pname = "redis-plus-plus";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "sewenew";
    repo = "redis-plus-plus";
    rev = version;
    sha256 = "sha256-QCNN85syxw2EGPdyTV3bL0txcHl7t2YhsKwK9lgnexY=";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ hiredis libuv ];

  cmakeFlags = [
    "-DREDIS_PLUS_PLUS_BUILD_TEST=OFF"
  ] ++ lib.optionals (!enableShared) [
    "-DREDIS_PLUS_PLUS_BUILD_SHARED=OFF"
  ] ++ lib.optionals (!enableStatic) [
    "-DREDIS_PLUS_PLUS_BUILD_STATIC=OFF"
  ] ++ [
    "-DREDIS_PLUS_PLUS_BUILD_ASYNC=libuv"
  ];

  meta = with lib; {
    homepage = "https://github.com/sewenew/redis-plus-plus";
    description = "Redis client written in C++";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wheelsandmetal sebastiaan ];
  };
}
