{ lib, stdenv, fetchFromGitHub, cmake, boost, gtest, rapidjson, rdkafka }:

stdenv.mkDerivation rec {
  pname = "modern-cpp-kafka";
  version = "2023.03.07";

  src = fetchFromGitHub {
    owner = "morganstanley";
    repo = "modern-cpp-kafka";
    rev = "v${version}";
    sha256 = "sha256-7hkwM1YbveQpDRqwMZ3MXM88LTwlAT7uB8NL0t409To=";
  };

  patches = [
    # The lib expects headers and lib is in common dir, but nix splits them into out and dev derivations
    # Purpose of this patch is to separate GTEST_ROOT into two variables, so we can point each of them to different location
    ./gtest_envs.patch
  ];
  # Envs used by the patch
  GTEST_INCLUDE_DIR = "${gtest.dev}/include";
  GTEST_LIBRARY_DIR = "${gtest}/lib";

  cmakeFlags = [
    "-DCMAKE_INCLUDE_PATH=${rdkafka}/include/librdkafka;${rapidjson}/include/rapidjson"
  ];

  nativeBuildInputs = [ cmake boost.dev gtest gtest.dev rapidjson ];

  buildInputs = [ rdkafka ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A C++ API for Kafka clients (i.e. KafkaProducer, KafkaConsumer, AdminClient)";
    homepage = "https://github.com/morganstanley/modern-cpp-kafka";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [];
  };
}
