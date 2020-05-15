{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake
, opentracing-cpp, protobuf, zlib
, enableGrpc ? false, grpc ? null, openssl ? null, c-ares ? null
}:

assert enableGrpc -> grpc != null;
assert enableGrpc -> openssl != null;
assert enableGrpc -> c-ares != null;

stdenv.mkDerivation rec {
  pname = "lightstep-tracer-cpp";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lightstep";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zwj5r0rmfk6cm5ikay4kh7na455vskylc5yrxkhisn4n850d1l4";
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
