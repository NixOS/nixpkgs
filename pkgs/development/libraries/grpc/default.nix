{ lib
, stdenv
, runCommand
, fetchFromGitHub
, fetchpatch
, buildPackages
, cmake
, lndir
, zlib
, c-ares
, pkg-config
, re2
, openssl
, protobuf
, grpc
, abseil-cpp
, libnsl

# tests
, python3
, arrow-cpp
}:

stdenv.mkDerivation rec {
  pname = "grpc";
  version = "1.62.1"; # N.B: if you change this, please update:
    # pythonPackages.grpcio-tools
    # pythonPackages.grpcio-status

  # the following expression has been generated using
  # https://codeberg.org/gm6k/git-unroll
  src =
    assert version == "1.62.1";
    (rec {
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
      src_abseil-cpp_protobuf = fetchFromGitHub {
        owner = "abseil";
        repo = "abseil-cpp";
        rev = "fb3621f4f897824c0dbe0615fa94543df6192f30";
        hash = "sha256-uNGrTNg5G5xFGtc+BSWE389x0tQ/KxJQLHfebNWas/k=";
      };
      src_benchmark = fetchFromGitHub {
        owner = "google";
        repo = "benchmark";
        rev = "344117638c8ff7e239044fd0fa7085839fc03021";
        hash = "sha256-gztnxui9Fe/FTieMjdvfJjWHjkImtlsHn6fM1FruyME=";
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
        rev = "ae72a4514c7afd150596b0a80947f3ca9b8363b5";
        hash = "sha256-QYwuiEXYffZpJUfE0CVqJdGRKK7cXUisBZUSdL8LwJw=";
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
      src_data-plane-api = fetchFromGitHub {
        owner = "envoyproxy";
        repo = "data-plane-api";
        rev = "78f198cf96ecdc7120ef640406770aa01af775c4";
        hash = "sha256-gselhnjEnRwWTfzrHbM2yhoEIdNJODRvc98VgKLRZx0=";
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
        rev = "v1.62.1";
        hash = "sha256-oHASYiTeQOmQAh3yQgDqmEUNknFjW85bya7kMW2JPfM=";
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
      src_opentelemetry-proto = fetchFromGitHub {
        owner = "open-telemetry";
        repo = "opentelemetry-proto";
        rev = "60fa8754d890b5c55949a8c68dcfd7ab5c2395df";
        hash = "sha256-iyRqAwIOx6b1GezMordIWsAJNPmTRHJOf9437dGnNDg=";
      };
      src_protobuf = fetchFromGitHub {
        owner = "protocolbuffers";
        repo = "protobuf";
        rev = "7f94235e552599141950d7a4a3eaf93bc87d1b22";
        hash = "sha256-w6556kxftVZ154LrZB+jv9qK+QmMiUOGj6EcNwiV+yo=";
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
      src_abseil-cpp_recursive = src_abseil-cpp;
      src_abseil-cpp_bloaty_recursive = src_abseil-cpp_bloaty;
      src_abseil-cpp_protobuf_recursive = src_abseil-cpp_protobuf;
      src_benchmark_recursive = src_benchmark;
      src_benchmark_protobuf_bloaty_recursive = src_benchmark_protobuf_bloaty;
      src_bloaty_recursive = runCommand "bloaty" {} ''
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
      src_data-plane-api_recursive = src_data-plane-api;
      src_demumble_recursive = src_demumble;
      src_googleapis_recursive = src_googleapis;
      src_googletest_recursive = src_googletest;
      src_googletest_bloaty_recursive = src_googletest_bloaty;
      src_googletest_protobuf_recursive = src_googletest_protobuf;
      src_googletest_protobuf_bloaty_recursive = src_googletest_protobuf_bloaty;
      src_grpc_recursive = runCommand "grpc" {} ''
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
      src_jsoncpp_recursive = src_jsoncpp;
      src_opencensus-proto_recursive = src_opencensus-proto;
      src_opentelemetry-proto_recursive = src_opentelemetry-proto;
      src_protobuf_recursive = runCommand "protobuf" {} ''
        cp -r ${src_protobuf} $out
        chmod u+w $out/third_party/abseil-cpp
        ${lndir}/bin/lndir ${src_abseil-cpp_protobuf_recursive} $out/third_party/abseil-cpp
        chmod u+w $out/third_party/googletest
        ${lndir}/bin/lndir ${src_googletest_protobuf_recursive} $out/third_party/googletest
        chmod u+w $out/third_party/jsoncpp
        ${lndir}/bin/lndir ${src_jsoncpp_recursive} $out/third_party/jsoncpp
      '';
      src_protobuf_bloaty_recursive = runCommand "protobuf_bloaty" {} ''
        cp -r ${src_protobuf_bloaty} $out
        chmod u+w $out/third_party/benchmark
        ${lndir}/bin/lndir ${src_benchmark_protobuf_bloaty_recursive} $out/third_party/benchmark
        chmod u+w $out/third_party/googletest
        ${lndir}/bin/lndir ${src_googletest_protobuf_bloaty_recursive} $out/third_party/googletest
      '';
      src_protoc-gen-validate_recursive = src_protoc-gen-validate;
      src_re2_recursive = src_re2;
      src_re2_bloaty_recursive = src_re2_bloaty;
      src_xds_recursive = src_xds;
      src_zlib_recursive = src_zlib;
      src_zlib_bloaty_recursive = src_zlib_bloaty;
    }).src_grpc_recursive;

  patches = [
    (fetchpatch {
      # armv6l support, https://github.com/grpc/grpc/pull/21341
      name = "grpc-link-libatomic.patch";
      url = "https://github.com/lopsided98/grpc/commit/a9b917666234f5665c347123d699055d8c2537b2.patch";
      hash = "sha256-Lm0GQsz/UjBbXXEE14lT0dcRzVmCKycrlrdBJj+KLu8=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) grpc;
  propagatedBuildInputs = [ c-ares re2 zlib abseil-cpp ];
  buildInputs = [ openssl protobuf ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libnsl ];

  cmakeFlags = [
    "-DgRPC_ZLIB_PROVIDER=package"
    "-DgRPC_CARES_PROVIDER=package"
    "-DgRPC_RE2_PROVIDER=package"
    "-DgRPC_SSL_PROVIDER=package"
    "-DgRPC_PROTOBUF_PROVIDER=package"
    "-DgRPC_ABSL_PROVIDER=package"
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-D_gRPC_PROTOBUF_PROTOC_EXECUTABLE=${buildPackages.protobuf}/bin/protoc"
    "-D_gRPC_CPP_PLUGIN=${buildPackages.grpc}/bin/grpc_cpp_plugin"
  ]
  # The build scaffold defaults to c++14 on darwin, even when the compiler uses
  # a more recent c++ version by default [1]. However, downgrades are
  # problematic, because the compatibility types in abseil will have different
  # interface definitions than the ones used for building abseil itself.
  # [1] https://github.com/grpc/grpc/blob/v1.57.0/CMakeLists.txt#L239-L243
  ++ (let
    defaultCxxIsOlderThan17 =
      (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.cc.version "16.0")
       || (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.cc.version "11.0");
    in lib.optionals (stdenv.hostPlatform.isDarwin && defaultCxxIsOlderThan17)
  [
    "-DCMAKE_CXX_STANDARD=17"
  ]);

  # CMake creates a build directory by default, this conflicts with the
  # basel BUILD file on case-insensitive filesystems.
  preConfigure = ''
    rm -vf BUILD
  '';

  # When natively compiling, grpc_cpp_plugin is executed from the build directory,
  # needing to load dynamic libraries from the build directory, so we set
  # LD_LIBRARY_PATH to enable this. When cross compiling we need to avoid this,
  # since it can cause the grpc_cpp_plugin executable from buildPackages to
  # crash if build and host architecture are compatible (e. g. pkgsLLVM).
  preBuild = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    export LD_LIBRARY_PATH=$(pwd)''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  '';

  env.NIX_CFLAGS_COMPILE = toString ([
    "-Wno-error"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Workaround for https://github.com/llvm/llvm-project/issues/48757
    "-Wno-elaborated-enum-base"
  ]);

  enableParallelBuilds = true;

  passthru.tests = {
    inherit (python3.pkgs) grpcio-status grpcio-tools jaxlib;
    inherit arrow-cpp;
  };

  meta = with lib; {
    description = "C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)";
    license = licenses.asl20;
    maintainers = with maintainers; [ lnl7 ];
    homepage = "https://grpc.io/";
    platforms = platforms.all;
    changelog = "https://github.com/grpc/grpc/releases/tag/v${version}";
  };
}
