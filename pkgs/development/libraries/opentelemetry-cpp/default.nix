{ stdenv, lib, fetchFromGitHub, cmake, protobuf, grpc, pkg-config, openssl }: let

  proto = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "v0.19.0";
    sha256 = "sha256-QWjGY0yW1XcrnvwWJ3QPr/8NJgoyQV5gFIn/ZI1dTaQ=";
    # needed for detection by cmake
    postFetch = ''
      touch $out/.git
    '';
  };

in stdenv.mkDerivation rec {
  pname = "opentelemetry-cpp";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-cpp";
    rev = "v${version}";
    hash = "sha256-Jc3dZxr570exw5gvUX98PQzrxoTes1F0OCaQ9JCzx4c=";
  };

  prePatch = ''
    rmdir third_party/opentelemetry-proto
    ln -s ${proto} third_party/opentelemetry-proto
  '';

  nativeBuildInputs = [ cmake protobuf pkg-config ];
  buildInputs = [ protobuf grpc openssl ];

  cmakeFlags = [
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    "-DWITH_OTLP=ON"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = {
    description = "The OpenTelemetry C++ Client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ das_j ];
  };
}
