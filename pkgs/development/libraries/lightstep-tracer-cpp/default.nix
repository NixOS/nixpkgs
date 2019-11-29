{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake
, opentracing-cpp, protobuf, zlib
, enableGrpc ? false, grpc ? null, openssl ? null, c-ares ? null
}:

assert enableGrpc -> grpc != null;
assert enableGrpc -> openssl != null;
assert enableGrpc -> c-ares != null;

stdenv.mkDerivation rec {
  pname = "lightstep-tracer-cpp";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lightstep";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x7n3b5i9a0481azy3ymfybjfvr5z0i8wm17d964hsv7ryvnapj0";
  };

  nativeBuildInputs = [
    cmake pkgconfig
  ];

  buildInputs = [
    opentracing-cpp protobuf zlib
  ] ++ lib.optionals enableGrpc [
    grpc openssl c-ares c-ares.cmake-config
  ];

  cmakeFlags = lib.optionals (!enableGrpc) [ "-DWITH_GRPC=OFF" ];

  meta = with lib; {
    description = "Distributed tracing system built on top of the OpenTracing standard";
    homepage = "https://lightstep.com/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
