{
  version,
  fetchFromGitHub,
  runCommand,
  lndir,
}:
assert version == "1.66.1";
(rec {
  src_GSL = fetchFromGitHub {
    owner = "microsoft";
    repo = "GSL";
    rev = "6f4529395c5b7c2d661812257cd6780c67e54afa";
    hash = "sha256-sNTDH1ohz+rcnBvA5KkarHKdRMQPW0c2LeSVPdEYx6Q=";
  };
  src_abseil-cpp = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "4a2c63365eff8823a5221db86ef490e828306f9d";
    hash = "sha256-HtJh2oYGx87bNT6Ll3WLeYPPxH1f9JwVqCXGErykGnE=";
  };
  src_abseil-cpp_bloaty = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "5dd240724366295970c613ed23d0092bcf392f18";
    hash = "sha256-SPZ9jSoJP8J1Kdtw6Lk1XDqlJX2DbrIBV0//bDV/VBw=";
  };
  src_benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "344117638c8ff7e239044fd0fa7085839fc03021";
    hash = "sha256-gztnxui9Fe/FTieMjdvfJjWHjkImtlsHn6fM1FruyME=";
  };
  src_benchmark_opentelemetry-cpp = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "d572f4777349d43653b21d6c2fc63020ab326db2";
    hash = "sha256-gg3g/0Ki29FnGqKv9lDTs5oA9NjH23qQ+hTdVtSU+zo=";
  };
  src_benchmark_protobuf_bloaty = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8";
    hash = "sha256-iFRgjLkftuszAqBnmS9GXU8BwYnabmwMAQyw19sfjb4=";
  };
  src_bloaty = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "60209eb1ccc34d5deefb002d1b7f37545204f7f2";
    hash = "sha256-Yog96+5DHBXmxNfaeXuEP3knPV7WiTKXJhNvovMaZdU=";
  };
  src_boringssl = fetchFromGitHub {
    owner = "google";
    repo = "boringssl";
    rev = "16c8d3db1af20fcc04b5190b25242aadcb1fbb30";
    hash = "sha256-VM5m9CmSbz9Sr8B1uRQDhiacY4mcUjlb+FvqGAVm/lY=";
  };
  src_c-ares = fetchFromGitHub {
    owner = "c-ares";
    repo = "c-ares";
    rev = "6360e96b5cf8e5980c887ce58ef727e53d77243a";
    hash = "sha256-4K4XxXiSotUoVOciBVWANjfOlhwtno0jJq52GI8WTQ0=";
  };
  src_capstone = fetchFromGitHub {
    owner = "aquynh";
    repo = "capstone";
    rev = "852f46a467cb37559a1f3a18bd45d5ca8c6fc5e7";
    hash = "sha256-Vbb6e8MGzwHDDvlLfRKBkohzYRN1soSTqK4Yov3q8Yc=";
  };
  src_civetweb = fetchFromGitHub {
    owner = "civetweb";
    repo = "civetweb";
    rev = "eefb26f82b233268fc98577d265352720d477ba4";
    hash = "sha256-Qh6BGPk7a01YzCeX42+Og9M+fjXRs7kzNUCyT4mYab4=";
  };
  src_data-plane-api = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "data-plane-api";
    rev = "f8b75d1efa92bbf534596a013d9ca5873f79dd30";
    hash = "sha256-TbnLDjt1i4zn9CZf1dTMWauiqsa0cJDbOmhvqise1ig=";
  };
  src_demumble = fetchFromGitHub {
    owner = "nico";
    repo = "demumble";
    rev = "01098eab821b33bd31b9778aea38565cd796aa85";
    hash = "sha256-605SsXd7TSdm3BH854ChHIZbOXcHI/n8RN+pFMz4Ex4=";
  };
  src_googleapis = fetchFromGitHub {
    owner = "googleapis";
    repo = "googleapis";
    rev = "2f9af297c84c55c8b871ba4495e01ade42476c92";
    hash = "sha256-2FGy1ZjWULIS6ZFRyLEiJxSXdVUAIj0B/Y3k4ObeFNU=";
  };
  src_googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "2dd1c131950043a8ad5ab0d2dda0e0970596586a";
    hash = "sha256-CAFtKpj0hM9Gxdmzqpxp/enmc9QFfAXB79e30dcVyOc=";
  };
  src_googletest_bloaty = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "565f1b848215b77c3732bca345fe76a0431d8b34";
    hash = "sha256-mZmoValE5+QfEeSktYTaQb+3khe5vQDRSabvYI0gy/I=";
  };
  src_googletest_opentelemetry-cpp = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "b796f7d44681514f58a683a3a71ff17c94edb0c1";
    hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
  };
  src_googletest_prometheus-cpp = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "e2239ee6043f73722e7aa812a459f54a28552929";
    hash = "sha256-SjlJxushfry13RGA7BCjYC9oZqV4z6x8dOiHfl/wpF0=";
  };
  src_googletest_protobuf = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "4c9a3bb62bf3ba1f1010bf96f9c8ed767b363774";
    hash = "sha256-y3cZF2mBPOX+TAMwc3OKrv0jAEa1p6Zzu/08JHA7L2w=";
  };
  src_googletest_protobuf_bloaty = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081";
    hash = "sha256-Zh7t6kOabEZxIuTwREerNSgbZLPnGWv78h0wQQAIuT4=";
  };
  src_grpc = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v1.66.1";
    hash = "sha256-WhoNTJ5wpW78IOCF2s3C6ENymzhXAiVvNoZ0csTq1y0=";
  };
  src_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "bc889afb4c5bf1c0d8ee29ef35eaaf4c8bef8a5d";
    hash = "sha256-SUdhIV7tjtacf5DkoWk9cnkfyMlrkg8ZU7XnPZd22Tw=";
  };
  src_jsoncpp = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = "9059f5cad030ba11d37818847443a53918c327b1";
    hash = "sha256-m0tz8w8HbtDitx3Qkn3Rxj/XhASiJVkThdeBxIwv3WI=";
  };
  src_opencensus-proto = fetchFromGitHub {
    owner = "census-instrumentation";
    repo = "opencensus-proto";
    rev = "4aa53e15cbf1a47bc9087e6cfdca214c1eea4e89";
    hash = "sha256-znBlptbYKfl2nrDN4/X31ccnPKOcXymjhqoXMpY099k=";
  };
  src_opentelemetry-cpp = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-cpp";
    rev = "4bd64c9a336fd438d6c4c9dad2e6b61b0585311f";
    hash = "sha256-Tf1ZnmHavnwwvRb4Tes20LMld+w/2kRo5UErT8pHf3w=";
  };
  src_opentelemetry-proto = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "60fa8754d890b5c55949a8c68dcfd7ab5c2395df";
    hash = "sha256-iyRqAwIOx6b1GezMordIWsAJNPmTRHJOf9437dGnNDg=";
  };
  src_opentelemetry-proto_opentelemetry-cpp = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "c4dfbc51f3cd4089778555a2ac5d9bc093ed2956";
    hash = "sha256-1IylAZs8gElpruSX52A+ZopU8jXH/MjRE+FQV3gQ+Gk=";
  };
  src_opentracing-cpp = fetchFromGitHub {
    owner = "opentracing";
    repo = "opentracing-cpp";
    rev = "06b57f48ded1fa3bdd3d4346f6ef29e40e08eaf5";
    hash = "sha256-XlQi26ynXKDwA86DwsDw+hhKR8bcdnrtFH1CpAzVlLs=";
  };
  src_prometheus-cpp = fetchFromGitHub {
    owner = "jupp0r";
    repo = "prometheus-cpp";
    rev = "c9ffcdda9086ffd9e1283ea7a0276d831f3c8a8d";
    hash = "sha256-qx6oBxd0YrUyFq+7ArnKBqOwrl5X8RS9nErhRDUJ7+8=";
  };
  src_protobuf = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "63def39e881afa496502d9c410f4ea948e59490d";
    hash = "sha256-9avetEoB51WblGRy/7FTmhCb06Vi1JfwWv2dxJvna2U=";
  };
  src_protobuf_bloaty = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "bc1773c42c9c3c522145a3119e989e0dff2a8d54";
    hash = "sha256-EDaz1lDS3hIdOYeK4vADRKhVQH3STepGh5GJ1SFvvbw=";
  };
  src_protoc-gen-validate = fetchFromGitHub {
    owner = "envoyproxy";
    repo = "protoc-gen-validate";
    rev = "fab737efbb4b4d03e7c771393708f75594b121e4";
    hash = "sha256-sztpUzrVvYT3GFVbfd91rOudj/PEHHizTOzTrH1fQts=";
  };
  src_re2 = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = "0c5616df9c0aaa44c9440d87422012423d91c7d1";
    hash = "sha256-ywmXIAyVWYMKBOsAndcq7dFYpn9ZgNz5YWTPjylXxsk=";
  };
  src_re2_bloaty = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = "5bd613749fd530b576b890283bfb6bc6ea6246cb";
    hash = "sha256-xHrcRHJja1o4yEksyTVK8srJ47JSZ5+fFn+fbsEdFag=";
  };
  src_vcpkg = fetchFromGitHub {
    owner = "Microsoft";
    repo = "vcpkg";
    rev = "8eb57355a4ffb410a2e94c07b4dca2dffbee8e50";
    hash = "sha256-u+4vyOphnowoaZgfkCbzF7Q4tuz2GN1bHylaKw352Lc=";
  };
  src_xds = fetchFromGitHub {
    owner = "cncf";
    repo = "xds";
    rev = "3a472e524827f72d1ad621c4983dd5af54c46776";
    hash = "sha256-4fJxmqg0JkjSVm6IHaqu1OJw2K+i9qAUELLSC0oGwlM=";
  };
  src_zlib = fetchFromGitHub {
    owner = "madler";
    repo = "zlib";
    rev = "09155eaa2f9270dc4ed1fa13e2b4b2613e6e4851";
    hash = "sha256-eUuXV5zfy+fmiMNdWw5QCqDloBkaxy1tgi7by9nYHNA=";
  };
  src_zlib_bloaty = fetchFromGitHub {
    owner = "madler";
    repo = "zlib";
    rev = "cacf7f1d4e3d44d871b605da3b647f07d718623f";
    hash = "sha256-j5b6aki1ztrzfCqu8y729sPar8GpyQWIrajdzpJC+ww=";
  };
  src_GSL_recursive = src_GSL;
  src_abseil-cpp_recursive = src_abseil-cpp;
  src_abseil-cpp_bloaty_recursive = src_abseil-cpp_bloaty;
  src_benchmark_recursive = src_benchmark;
  src_benchmark_opentelemetry-cpp_recursive = src_benchmark_opentelemetry-cpp;
  src_benchmark_protobuf_bloaty_recursive = src_benchmark_protobuf_bloaty;
  src_bloaty_recursive = runCommand "bloaty" { } ''
    cp -r ${src_bloaty} $out
    chmod u+w $out/third_party/abseil-cpp
    ${lndir}/bin/lndir ${src_abseil-cpp_bloaty_recursive} $out/third_party/abseil-cpp
    chmod u+w $out/third_party/capstone
    ${lndir}/bin/lndir ${src_capstone_recursive} $out/third_party/capstone
    chmod u+w $out/third_party/demumble
    ${lndir}/bin/lndir ${src_demumble_recursive} $out/third_party/demumble
    chmod u+w $out/third_party/googletest
    ${lndir}/bin/lndir ${src_googletest_bloaty_recursive} $out/third_party/googletest
    chmod u+w $out/third_party/protobuf
    ${lndir}/bin/lndir ${src_protobuf_bloaty_recursive} $out/third_party/protobuf
    chmod u+w $out/third_party/re2
    ${lndir}/bin/lndir ${src_re2_bloaty_recursive} $out/third_party/re2
    chmod u+w $out/third_party/zlib
    ${lndir}/bin/lndir ${src_zlib_bloaty_recursive} $out/third_party/zlib
  '';
  src_boringssl_recursive = src_boringssl;
  src_c-ares_recursive = src_c-ares;
  src_capstone_recursive = src_capstone;
  src_civetweb_recursive = src_civetweb;
  src_data-plane-api_recursive = src_data-plane-api;
  src_demumble_recursive = src_demumble;
  src_googleapis_recursive = src_googleapis;
  src_googletest_recursive = src_googletest;
  src_googletest_bloaty_recursive = src_googletest_bloaty;
  src_googletest_opentelemetry-cpp_recursive = src_googletest_opentelemetry-cpp;
  src_googletest_prometheus-cpp_recursive = src_googletest_prometheus-cpp;
  src_googletest_protobuf_recursive = src_googletest_protobuf;
  src_googletest_protobuf_bloaty_recursive = src_googletest_protobuf_bloaty;
  src_grpc_recursive = runCommand "grpc" { } ''
    cp -r ${src_grpc} $out
    chmod u+w $out/third_party/abseil-cpp
    ${lndir}/bin/lndir ${src_abseil-cpp_recursive} $out/third_party/abseil-cpp
    chmod u+w $out/third_party/benchmark
    ${lndir}/bin/lndir ${src_benchmark_recursive} $out/third_party/benchmark
    chmod u+w $out/third_party/bloaty
    ${lndir}/bin/lndir ${src_bloaty_recursive} $out/third_party/bloaty
    chmod u+w $out/third_party/boringssl-with-bazel
    ${lndir}/bin/lndir ${src_boringssl_recursive} $out/third_party/boringssl-with-bazel
    chmod u+w $out/third_party/cares/cares
    ${lndir}/bin/lndir ${src_c-ares_recursive} $out/third_party/cares/cares
    chmod u+w $out/third_party/envoy-api
    ${lndir}/bin/lndir ${src_data-plane-api_recursive} $out/third_party/envoy-api
    chmod u+w $out/third_party/googleapis
    ${lndir}/bin/lndir ${src_googleapis_recursive} $out/third_party/googleapis
    chmod u+w $out/third_party/googletest
    ${lndir}/bin/lndir ${src_googletest_recursive} $out/third_party/googletest
    chmod u+w $out/third_party/opencensus-proto
    ${lndir}/bin/lndir ${src_opencensus-proto_recursive} $out/third_party/opencensus-proto
    chmod u+w $out/third_party/opentelemetry
    ${lndir}/bin/lndir ${src_opentelemetry-proto_recursive} $out/third_party/opentelemetry
    chmod u+w $out/third_party/opentelemetry-cpp
    ${lndir}/bin/lndir ${src_opentelemetry-cpp_recursive} $out/third_party/opentelemetry-cpp
    chmod u+w $out/third_party/protobuf
    ${lndir}/bin/lndir ${src_protobuf_recursive} $out/third_party/protobuf
    chmod u+w $out/third_party/protoc-gen-validate
    ${lndir}/bin/lndir ${src_protoc-gen-validate_recursive} $out/third_party/protoc-gen-validate
    chmod u+w $out/third_party/re2
    ${lndir}/bin/lndir ${src_re2_recursive} $out/third_party/re2
    chmod u+w $out/third_party/xds
    ${lndir}/bin/lndir ${src_xds_recursive} $out/third_party/xds
    chmod u+w $out/third_party/zlib
    ${lndir}/bin/lndir ${src_zlib_recursive} $out/third_party/zlib
  '';
  src_json_recursive = src_json;
  src_jsoncpp_recursive = src_jsoncpp;
  src_opencensus-proto_recursive = src_opencensus-proto;
  src_opentelemetry-cpp_recursive = runCommand "opentelemetry-cpp" { } ''
    cp -r ${src_opentelemetry-cpp} $out
    chmod u+w $out/third_party/benchmark
    ${lndir}/bin/lndir ${src_benchmark_opentelemetry-cpp_recursive} $out/third_party/benchmark
    chmod u+w $out/third_party/googletest
    ${lndir}/bin/lndir ${src_googletest_opentelemetry-cpp_recursive} $out/third_party/googletest
    chmod u+w $out/third_party/ms-gsl
    ${lndir}/bin/lndir ${src_GSL_recursive} $out/third_party/ms-gsl
    chmod u+w $out/third_party/nlohmann-json
    ${lndir}/bin/lndir ${src_json_recursive} $out/third_party/nlohmann-json
    chmod u+w $out/third_party/opentelemetry-proto
    ${lndir}/bin/lndir ${src_opentelemetry-proto_opentelemetry-cpp_recursive} $out/third_party/opentelemetry-proto
    chmod u+w $out/third_party/opentracing-cpp
    ${lndir}/bin/lndir ${src_opentracing-cpp_recursive} $out/third_party/opentracing-cpp
    chmod u+w $out/third_party/prometheus-cpp
    ${lndir}/bin/lndir ${src_prometheus-cpp_recursive} $out/third_party/prometheus-cpp
    chmod u+w $out/tools/vcpkg
    ${lndir}/bin/lndir ${src_vcpkg_recursive} $out/tools/vcpkg
  '';
  src_opentelemetry-proto_recursive = src_opentelemetry-proto;
  src_opentelemetry-proto_opentelemetry-cpp_recursive = src_opentelemetry-proto_opentelemetry-cpp;
  src_opentracing-cpp_recursive = src_opentracing-cpp;
  src_prometheus-cpp_recursive = runCommand "prometheus-cpp" { } ''
    cp -r ${src_prometheus-cpp} $out
    chmod u+w $out/3rdparty/civetweb
    ${lndir}/bin/lndir ${src_civetweb_recursive} $out/3rdparty/civetweb
    chmod u+w $out/3rdparty/googletest
    ${lndir}/bin/lndir ${src_googletest_prometheus-cpp_recursive} $out/3rdparty/googletest
  '';
  src_protobuf_recursive = runCommand "protobuf" { } ''
    cp -r ${src_protobuf} $out
    chmod u+w $out/third_party/abseil-cpp
    ${lndir}/bin/lndir ${src_abseil-cpp_recursive} $out/third_party/abseil-cpp
    chmod u+w $out/third_party/googletest
    ${lndir}/bin/lndir ${src_googletest_protobuf_recursive} $out/third_party/googletest
    chmod u+w $out/third_party/jsoncpp
    ${lndir}/bin/lndir ${src_jsoncpp_recursive} $out/third_party/jsoncpp
  '';
  src_protobuf_bloaty_recursive = runCommand "protobuf_bloaty" { } ''
    cp -r ${src_protobuf_bloaty} $out
    chmod u+w $out/third_party/benchmark
    ${lndir}/bin/lndir ${src_benchmark_protobuf_bloaty_recursive} $out/third_party/benchmark
    chmod u+w $out/third_party/googletest
    ${lndir}/bin/lndir ${src_googletest_protobuf_bloaty_recursive} $out/third_party/googletest
  '';
  src_protoc-gen-validate_recursive = src_protoc-gen-validate;
  src_re2_recursive = src_re2;
  src_re2_bloaty_recursive = src_re2_bloaty;
  src_vcpkg_recursive = src_vcpkg;
  src_xds_recursive = src_xds;
  src_zlib_recursive = src_zlib;
  src_zlib_bloaty_recursive = src_zlib_bloaty;
}).src_grpc_recursive
# Update using: unroll-src [version]
