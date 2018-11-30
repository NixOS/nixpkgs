{ stdenv, lib, fetchFromGitHub, pkgconfig, protobuf, cmake, zlib
, opentracing-cpp, enableGrpc ? false
}:

let
  # be sure to use the right revision based on the submodule!
  common =
    fetchFromGitHub {
      owner = "lightstep";
      repo = "lightstep-tracer-common";
      rev = "5fe3bf885bcece14c3c65df06c86c826ba45ad69";
      sha256 = "1q39a0zaqbnqyhl2hza2xzc44235p65bbkfkzs2981niscmggq8w";
    };

in

stdenv.mkDerivation rec {
  name = "lightstep-tracer-cpp-${version}";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "lightstep";
    repo = "lightstep-tracer-cpp";
    rev = "v${version}";
    sha256 = "1m4kl70lhvy1bsmkdh6bf2fddz5v1ikb27vgi99i2akpq40g4fvf";
  };

  postUnpack = ''
    cp -r ${common}/* $sourceRoot/lightstep-tracer-common
  '';

  cmakeFlags = ["-DOPENTRACING_INCLUDE_DIR=${opentracing-cpp}/include" "-DOPENTRACING_LIBRARY=${opentracing-cpp}/lib/libopentracing.so"] ++ lib.optional (!enableGrpc) [ "-DWITH_GRPC=OFF" ];

  nativeBuildInputs = [
    pkgconfig cmake
  ];

  buildInputs = [
    protobuf zlib
  ];

  meta = with lib; {
    description = "Distributed tracing system built on top of the OpenTracing standard";
    homepage = "https://lightstep.com/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
