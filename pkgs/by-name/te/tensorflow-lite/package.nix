{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  perl,
  autoPatchelfHook,
  pkg-config,
  eigen,
  git,
  runCommand,
  zlib,
  buildPackages,
  abseil-cpp,
  protobuf,
  farmhash,
}:
let
  fft-src = fetchFromGitHub {
    owner = "petewarden";
    repo = "OouraFFT";
    rev = "c6fd2dd6d21397baa6653139d31d84540d5449a2";
    sha256 = "sha256-mkG6jWuMVzCB433qk2wW/HPA9vp/LivPTDa2c0hFir4=";
  };

  gemmlowp-src = fetchFromGitHub {
    owner = "google";
    repo = "gemmlowp";
    rev = "16e8662c34917be0065110bfcd9cc27d30f52fdf";
    sha256 = "sha256-e6AeRhZioIiTG5R+IA9g2GBqI4o74wijJYmqINLOtQs=";
  };

  neon2sse-src = fetchFromGitHub {
    owner = "intel";
    repo = "ARM_NEON_2_x86_SSE";
    rev = "a15b489e1222b2087007546b4912e21293ea86ff";
    sha256 = "sha256-299ZptvdTmCnIuVVBkrpf5ZTxKPwgcGUob81tEI91F0=";
  };

  cpuinfo-src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "de0ce7c7251372892e53ce9bc891750d2c9a4fd8";
    hash = "sha256-lWD8fLIMnvuWtp2hbReRHgF19+dTqSFGu3VmYUsjPt8=";
  };

  ml_dtypes-src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    rev = "00d98cd92ade342fef589c0470379abb27baebe9";
    hash = "sha256-jY3g0+Uebdj+C2HLfXXq1fO/gnJMQQE/AE0RfxjI5f4=";
  };

  ruy-src = fetchFromGitHub {
    owner = "google";
    repo = "ruy";
    rev = "3286a34cc8de6149ac6844107dfdffac91531e72";
    sha256 = "sha256-2l2RA/VHF9VgHzkPtFdtpVQJtgUw+iT7q4rUBT4R3GE=";
  };

  pthreadpool-src = fetchFromGitHub {
    owner = "google";
    repo = "pthreadpool";
    rev = "c2ba5c50bb58d1397b693740cf75fad836a0d1bf";
    sha256 = "sha256-aAoOCv6rzMsgP4wbcOsmB102SZJp759wK4Hu+zm/6xM=";
  };

  fp16-src = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "FP16";
    rev = "0a92994d729ff76a58f692d3028ca1b64b145d91";
    sha256 = "sha256-m2d9bqZoGWzuUPGkd29MsrdscnJRtuIkLIMp3fMmtRY=";
  };

  fxdiv-src = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "FXdiv";
    rev = "63058eff77e11aa15bf531df5dd34395ec3017c8";
    sha256 = "sha256-LjX5kivfHbqCIA5pF9qUvswG1gjOFo3CMpX0VR+Cn38=";
  };

  opencl-src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "dcd5bede6859d26833cd85f0d6bbcee7382dc9b3";
    sha256 = "sha256-94rZeGuVvzQVBvwxpJWiiDs+RxTQqWKs0jeYzqBiQew=";
  };

  vulkan-src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = "32c07c0c5334aea069e518206d75e002ccd85389";
    sha256 = "sha256-drdsTSvhhsWqit94G0Nkg5obCp3UaC5F/1/ZwjOmots=";
  };

  opengl-src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenGL-Registry";
    rev = "0cb0880d91581d34f96899c86fc1bf35627b4b81";
    sha256 = "sha256-pSONBYgBPhelflF0DA1Uf5jyqLhGU0jr7DF35ZrIYyY=";
  };

  pthreadpool-modded = runCommand "pthreadpool-modded" { } ''
    mkdir -p $out
    cp -r '${pthreadpool-src}/.' $out/

    substituteInPlace $out/cmake/DownloadFXdiv.cmake \
      --replace-fail "GIT_REPOSITORY https://github.com/Maratyszcza/FXdiv.git" "URL file://${fxdiv-src}" \
      --replace-fail "GIT_TAG master" "URL_HASH SHA256=2e35f9922bdf1dba82200e6917da94becc06d608ce168dc23295f4551f829f7f"
  '';

  egl-src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "EGL-Registry";
    rev = "649981109e263b737e7735933c90626c29a306f2";
    sha256 = "sha256-X1tK/WB+zm+Y+bYywt6sxUb1cVc4YMZluW+wtiYcjE8=";
  };

  xnnpack-src = fetchFromGitHub {
    owner = "google";
    repo = "XNNPACK";
    rev = "585e73e63cb35c8a416c83a48ca9ab79f7f7d45e";
    sha256 = "sha256-mqJMVjZ4rn5O3J/qI/N7HbnMdMSarPYHTIqNBmjZv0Q=";
  };

  kleidiai-src = fetchFromGitHub {
    owner = "ARM-software";
    repo = "kleidiai";
    rev = "dc69e899945c412a8ce39ccafd25139f743c60b1";
    sha256 = "sha256-VLVITcDBCj1PLke4H+9bOBsEHSGI28bub5U1/5HxVpk=";
  };

  kleidiai-modded = runCommand "kleidiai-modded" { } ''
    mkdir -p $out
    cp -r '${kleidiai-src}/.' $out/

    substituteInPlace $out/cmake/FetchGTest.cmake \
      --replace-fail "URL         \''${CMAKE_CURRENT_SOURCE_DIR}/third_party/googletest-v1.14.0.zip" "URL file://${googletest-src}" \
      --replace-fail "URL_HASH    SHA256=1f357c27ca988c3f7c6b4bf68a9395005ac6761f034046e9dde0896e3aba00e4" "URL_HASH SHA256=2e35f9922bdf1dba82200e6917da94becc06d608ce168dc23295f4551f829f7f"

    substituteInPlace $out/cmake/FetchGBench.cmake \
      --replace-fail "URL         \''${CMAKE_CURRENT_SOURCE_DIR}/third_party/benchmark-v1.8.4.zip" "URL file://${googlebenchmark-src}" \
      --replace-fail "URL_HASH    SHA256=84c49c4c07074f36fbf8b4f182ed7d75191a6fa72756ab4a17848455499f4286" "URL_HASH SHA256=2e35f9922bdf1dba82200e6917da94becc06d608ce168dc23295f4551f829f7f"
  '';

  xnnpack-modded = runCommand "xnnpack-modded" { } ''
    mkdir -p $out
    cp -r '${xnnpack-src}/.' $out/

    substituteInPlace $out/cmake/DownloadKleidiAI.cmake \
      --replace-fail "URL https://github.com/ARM-software/kleidiai/archive/dc69e899945c412a8ce39ccafd25139f743c60b1.zip" "URL file://${kleidiai-modded}" \
      --replace-fail "URL_HASH SHA256=439926527fca9405ae90b602a3938d3435751ec78492e5f1c62d85f5df8c2784" "URL_HASH SHA256=2e35f9922bdf1dba82200e6917da94becc06d608ce168dc23295f4551f829f7f"
  '';

  flatbuffers-src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "e6463926479bd6b330cbcf673f7e917803fd5831";
    sha256 = "sha256-arpxR5mUXQctDIfCOgi7fOlJ9A+hcQKL3vQ3/rXgdWE=";
  };

  modded-flatbuffers = runCommand "patch-flatbuffers-for-musl" { } ''

      mkdir -p $out
      cp -r '${flatbuffers-src}/.' $out/

      substituteInPlace $out/CMakeLists.txt \
        --replace-fail 'if(NOT DEFINED FLATBUFFERS_LOCALE_INDEPENDENT)
      include(CheckCXXSymbolExists)' 'include(CheckCXXSymbolExists)
    if(NOT DEFINED FLATBUFFERS_LOCALE_INDEPENDENT)'

  '';

  googletest-src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-1.12.1";
    sha256 = "sha256-W+OxRTVtemt2esw4P7IyGWXOonUN5ZuscjvzqkYvZbM=";
  };

  googlebenchmark-src = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "v1.7.0";
    sha256 = "sha256-fQDktMUbVt8xerLmZT/v6mqnhQhji0Uf4hn6KnLFqfM=";
  };

  re2-src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = "2021-02-02";
    sha256 = "sha256-jOfcmuFvU7B67UjHZ0MwVHfrsTaN1Pem2uUHYmprZ2I=";
  };

  custom-flatc = buildPackages.flatbuffers.overrideAttrs {
    version = "24.3.25";
    src = modded-flatbuffers;
  };
in
stdenv.mkDerivation rec {
  pname = "tensorflow-lite";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "v${version}";
    hash = "sha256-nGWQ+T5FmL+hZucbjQlCRTJM1i//gSzua1QxcBFeqwM=";
  };

  nativeBuildInputs = [
    cmake
    python3
    perl
    autoPatchelfHook
    pkg-config
    git
  ];

  buildInputs = [
    eigen
    zlib
    abseil-cpp
  ];

  propagatedBuildInputs = [
    farmhash
  ];

  sourceRoot = "source/tensorflow/lite";

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DTFLITE_ENABLE_GPU=ON"
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-Wno-dev"
    "-DSYSTEM_FARMHASH=ON"
    "-DTFLITE_HOST_TOOLS_DIR=${custom-flatc}/bin"
    "-DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF"
    "-DBUILD_SHARED_LIBS=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DCMAKE_INSTALL_RPATH=\$ORIGIN/../lib"
  ];

  postPatch = ''
      # for gcc compatibility.
      sed -e '1i #include <cstdint>' -i kernels/internal/spectrogram.cc

      # patch network fetches of external projects

      substituteInPlace tools/cmake/modules/fft2d.cmake \
        --replace-fail "https://storage.googleapis.com/mirror.tensorflow.org/github.com/petewarden/OouraFFT/archive/v1.0.tar.gz" "file://${fft-src}"

      substituteInPlace tools/cmake/modules/gemmlowp.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/google/gemmlowp" "URL file://${gemmlowp-src}" \
        --replace-fail "GIT_TAG 16e8662c34917be0065110bfcd9cc27d30f52fdf" "URL_HASH SHA256=7ba01e461662a088931b947e200f60d8606a238a3be308a32589aa20d2ceb50b" \
        --replace-fail "# GIT_SHALLOW TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_URL \"file://${gemmlowp-src}/LICENSE\""

      substituteInPlace tools/cmake/modules/neon2sse.cmake \
        --replace-fail "https://storage.googleapis.com/mirror.tensorflow.org/github.com/intel/ARM_NEON_2_x86_SSE/archive/a15b489e1222b2087007546b4912e21293ea86ff.tar.gz" "file://${neon2sse-src}"

      substituteInPlace tools/cmake/modules/cpuinfo.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/pytorch/cpuinfo" "URL file://${cpuinfo-src}" \
        --replace-fail "GIT_TAG de0ce7c7251372892e53ce9bc891750d2c9a4fd8" "URL_HASH SHA256=9560fc7cb20c9efb96b69da16d17911e0175f7e753a92146bb7566614b233edf" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "SOURCE_DIR \"\''${CMAKE_BINARY_DIR}/cpuinfo\"" "LICENSE_URL \"file://${cpuinfo-src}/LICENSE\"
    SOURCE_DIR \"\''${CMAKE_BINARY_DIR}/cpuinfo\""

      substituteInPlace tools/cmake/modules/ml_dtypes.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/jax-ml/ml_dtypes" "URL file://${ml_dtypes-src}" \
        --replace-fail "GIT_TAG 00d98cd92ade342fef589c0470379abb27baebe9" "URL_HASH SHA256=8d8de0d3e51e6dd8fe0b61cb7d75ead5f3bf82724c41013f004d117f18c8e5fe" \
        --replace-fail "# GIT_SHALLOW TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_URL \"file://${ml_dtypes-src}/LICENSE\""

      substituteInPlace tools/cmake/modules/ruy.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/google/ruy" "URL file://${ruy-src}" \
        --replace-fail "GIT_TAG 3286a34cc8de6149ac6844107dfdffac91531e72" "URL_HASH SHA256=da5d9103f54717d5601f390fb4576da55409b60530fa24fbab8ad4053e11dc61" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "SOURCE_DIR \"\''${CMAKE_BINARY_DIR}/ruy\"" "LICENSE_URL \"file://${ruy-src}/LICENSE\"
    SOURCE_DIR \"\''${CMAKE_BINARY_DIR}/ruy\""

      substituteInPlace cmake/DownloadPThreadPool.cmake \
        --replace-fail "https://github.com/google/pthreadpool/archive/c2ba5c50bb58d1397b693740cf75fad836a0d1bf.zip" "file://${pthreadpool-modded}"

      substituteInPlace cmake/DownloadFP16.cmake \
        --replace-fail "https://github.com/Maratyszcza/FP16/archive/0a92994d729ff76a58f692d3028ca1b64b145d91.zip" "file://${fp16-src}"

      substituteInPlace tools/cmake/modules/opencl_headers.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/KhronosGroup/OpenCL-Headers" "URL file://${opencl-src}" \
        --replace-fail "GIT_TAG dcd5bede6859d26833cd85f0d6bbcee7382dc9b3" "URL_HASH SHA256=f78ad9786b95bf341506fc31a495a2883b3e4714d0a962acd23798cea06241ec" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "PREFIX \"\''${CMAKE_BINARY_DIR}\"" "LICENSE_URL \"file://${opencl-src}/LICENSE\"
    PREFIX \"\''${CMAKE_BINARY_DIR}\""

      substituteInPlace tools/cmake/modules/vulkan_headers.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/KhronosGroup/Vulkan-Headers" "URL file://${vulkan-src}" \
        --replace-fail "GIT_TAG 32c07c0c5334aea069e518206d75e002ccd85389" "URL_HASH SHA256=76b76c4d2be186c5aa8adf781b4364839a1b0a9dd4682e45ff5fd9c233a6a2db" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE.txt\"" \
        --replace-fail "PREFIX \"\''${CMAKE_BINARY_DIR}\"" "LICENSE_URL \"file://${vulkan-src}/LICENSE.txt\"
    PREFIX \"\''${CMAKE_BINARY_DIR}\""

      substituteInPlace tools/cmake/modules/opengl_headers.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/KhronosGroup/OpenGL-Registry.git" "URL file://${opengl-src}" \
        --replace-fail "GIT_TAG 0cb0880d91581d34f96899c86fc1bf35627b4b81" "URL_HASH SHA256=a5238d0588013e17a57e51740c0d547f98f2a8b8465348ebec3177e59ac86326" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE.txt\"" \
        --replace-fail "PREFIX \"\''${CMAKE_BINARY_DIR}\"" "#this repository does not contain a license file, but per https://www.khronos.org/legal/Khronos_Apache_2.0_CLA
    PREFIX \"\''${CMAKE_BINARY_DIR}\"" \
        --replace-fail "LICENSE_URL \"https://www.apache.org/licenses/LICENSE-2.0.txt\"" "LICENSE_URL \"file://${vulkan-src}/LICENSE.txt\""

      substituteInPlace tools/cmake/modules/egl_headers.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/KhronosGroup/EGL-Registry.git" "URL file://${egl-src}" \
        --replace-fail "GIT_TAG 649981109e263b737e7735933c90626c29a306f2" "URL_HASH SHA256=a5238d0588013e17a57e51740c0d547f98f2a8b8465348ebec3177e59ac86326" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE.txt\"" \
        --replace-fail "PREFIX \"\''${CMAKE_BINARY_DIR}\"" "#this repository does not contain a license file, but per https://www.khronos.org/legal/Khronos_Apache_2.0_CLA
    PREFIX \"\''${CMAKE_BINARY_DIR}\"" \
        --replace-fail "LICENSE_URL \"https://www.apache.org/licenses/LICENSE-2.0.txt\"" "LICENSE_URL \"file://${vulkan-src}/LICENSE.txt\""

      substituteInPlace tools/cmake/modules/xnnpack.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/google/XNNPACK" "URL file://${xnnpack-modded}" \
        --replace-fail "GIT_TAG 585e73e63cb35c8a416c83a48ca9ab79f7f7d45e" "URL_HASH SHA256=9aa24c563678ae7e4edc9fea23f37b1db9cc74c49aacf6074c8a8d0668d9bf44" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "PREFIX \"\''${CMAKE_BINARY_DIR}\"" "LICENSE_URL \"file://${xnnpack-modded}/LICENSE\"
    PREFIX \"\''${CMAKE_BINARY_DIR}\""

      substituteInPlace tools/cmake/modules/protobuf.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/protocolbuffers/protobuf" "URL file://${protobuf.src}" \
        --replace-fail "GIT_TAG 90b73ac3f0b10320315c2ca0d03a5a9b095d2f66" "URL_HASH SHA256=d7b58087052fc48403fd00b242094f544950dfc0ff275140df6859f10f24203d" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "PREFIX \"\''${CMAKE_BINARY_DIR}\"" "LICENSE_URL \"file://${protobuf.src}/LICENSE\"
    PREFIX \"\''${CMAKE_BINARY_DIR}\""

      substituteInPlace tools/cmake/modules/flatbuffers.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/google/flatbuffers" "URL file://${modded-flatbuffers}" \
        --replace-fail "GIT_TAG e6463926479bd6b330cbcf673f7e917803fd5831" "URL_HASH SHA256=6aba714799945d072d0c87c23a08bb7ce949f40fa171028bdef437feb5e07561" \
        --replace-fail "GIT_SHALLOW FALSE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_URL \"file://${modded-flatbuffers}/LICENSE\""

      substituteInPlace tools/cmake/modules/Findgoogletest.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/google/googletest.git" "URL file://${googletest-src}" \
        --replace-fail "GIT_TAG release-1.12.1" "URL_HASH SHA256=413cb0a900a4c8616975bb4306f530cfd6c65f16c9b3faa814a17acd80195264" \
        --replace-fail "GIT_SHALLOW TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_URL \"file://${googletest-src}/LICENSE\""

      substituteInPlace tools/cmake/modules/Findgoogle_benchmark.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/google/benchmark.git" "URL file://${googlebenchmark-src}" \
        --replace-fail "GIT_TAG v1.7.0" "URL_HASH SHA256=413cb0a900a4c8616975bb4306f530cfd6c65f16c9b3faa814a17acd80195264" \
        --replace-fail "GIT_SHALLOW TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_URL \"file://${googlebenchmark-src}/LICENSE\""

      substituteInPlace tools/cmake/modules/Findre2.cmake \
        --replace-fail "GIT_REPOSITORY https://github.com/google/re2.git" "URL file://${re2-src}" \
        --replace-fail "GIT_TAG 2021-02-02" "URL_HASH SHA256=413cb0a900a4c8616975bb4306f530cfd6c65f16c9b3faa814a17acd80195264" \
        --replace-fail "GIT_SHALLOW TRUE" "LICENSE_FILE \"LICENSE\"" \
        --replace-fail "GIT_PROGRESS TRUE" "LICENSE_URL \"file://${re2-src}/LICENSE\""

      # ugly way to force the correct protoc
      sed -i '22i\ \ \ set(Protobuf_PROTOC_EXECUTABLE "${buildPackages.protobuf}/bin/protoc")' profiling/proto/CMakeLists.txt

      chmod +w ../core/example
      chmod +w ../core/example/CMakeLists.txt
      sed -i '24i\ \ \ set(Protobuf_PROTOC_EXECUTABLE "${buildPackages.protobuf}/bin/protoc")' ../core/example/CMakeLists.txt

      # if building for musl, edit -DCMAKE_CXX_FLAGS="-DNOMINMAX=1" of flatbuffers.cmake to add -D_POSIX_SOURCE -D_GNU_SOURCE
      ${lib.optionalString stdenv.hostPlatform.isMusl ''
        substituteInPlace tools/cmake/modules/flatbuffers.cmake \
              --replace '-DCMAKE_CXX_FLAGS="-DNOMINMAX=1"' '-DCMAKE_CXX_FLAGS="-DNOMINMAX=1 -D_POSIX_SOURCE -D_GNU_SOURCE -DFLATBUFFERS_LOCALE_INDEPENDENT=0"' ''}

      ${lib.optionalString stdenv.hostPlatform.isMusl ''
        substituteInPlace tools/cmake/modules/flatbuffers.cmake \
              --replace 'add_definitions(-DNOMINMAX=1)' '
              add_definitions(-DNOMINMAX=1)
              add_definitions(-D_POSIX_SOURCE)
              add_definitions(-DFLATBUFFERS_LOCALE_INDEPENDENT=0)
              add_definitions(-D_GNU_SOURCE)' ''}
  '';

  preConfigure = ''
    cmakeFlagsArray+=(
       "-DCMAKE_CXX_FLAGS='-DTF_MAJOR_VERSION=2 -DTF_MINOR_VERSION=20 -DTF_PATCH_VERSION=0 -DTF_VERSION_SUFFIX=${"''"}  ${lib.optionalString stdenv.hostPlatform.isMusl "-D_POSIX_SOURCE -D_GNU_SOURCE -DFLATBUFFERS_LOCALE_INDEPENDENT=0 "}'"
      "-DCMAKE_C_FLAGS='-DTF_MAJOR_VERSION=2 -DTF_MINOR_VERSION=20 -DTF_PATCH_VERSION=0 -DTF_VERSION_SUFFIX=${"''"} ${lib.optionalString stdenv.hostPlatform.isMusl "-D_POSIX_SOURCE -D_GNU_SOURCE -DFLATBUFFERS_LOCALE_INDEPENDENT=0 "}'"
     )

    patchShebangs configure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,include}

    find . -type f -name '*.h' | while read f; do
      path="$out/include/''${f#./}"
      install -D "$f" "$path"
      chmod -x "$path"
    done

    ${
      if stdenv.hostPlatform.isStatic then
        ''
          find . -type f -name "*.a" -exec cp {} $out/lib \;
        ''
      else
        ''
          # copy libtensorflow-lite.so, libtensorflow-lite.so.2200, libtensorflow-lite.so.2.20.0 etc
          find . -name "*.so*" \( -type f -o -type l \) -exec cp -P {} $out/lib \;
        ''
    }

    runHook postInstall
  '';

  meta = {
    description = "Open source deep learning framework for on-device inference";
    homepage = "https://www.tensorflow.org/lite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mschwaig
      cpcloud
      crazychaoz
    ];

  };
}
