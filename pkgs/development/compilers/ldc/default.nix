{ stdenv, fetchFromGitHub, cmake, llvm, dmd, curl, tzdata, python,
  lit, gdb, unzip, darwin }:

stdenv.mkDerivation rec {
  name = "ldc-${version}";
  version = "1.3.0";

  srcs = [
  (fetchFromGitHub {
    owner = "ldc-developers";
    repo = "ldc";
    rev = "v${version}";
    sha256 = "1ac3j4cwwgjpayhijxx4d6478bc3iqksjxkd7xp7byx7k8w1ppdl";
    name = "ldc-v${version}-src";
  })
  (fetchFromGitHub {
    owner = "ldc-developers";
    repo = "druntime";
    rev = "ldc-v${version}";
    sha256 = "1m13370wnj3sizqk3sdpzi9am5d24srf27d613qblhqa9n8vwz30";
    name = "druntime-ldc-v${version}-src";
  })
  (fetchFromGitHub {
    owner = "ldc-developers";
    repo = "phobos";
    rev = "ldc-v${version}";
    sha256 = "0fhcdfi7a00plwj27ysfyv783nhk0kspq7hawf6vbsl3s1nyvn8g";
    name = "phobos-ldc-v${version}-src";
  })
  (fetchFromGitHub {
    owner = "ldc-developers";
    repo = "dmd-testsuite";
    rev = "ldc-v${version}";
    sha256 = "0dmdkp220gqhxjrmrjfkf0vsvylwfaj70hswavq4q3v4dg17pzmj";
    name = "dmd-testsuite-ldc-v${version}-src";
  })
  ];

  sourceRoot = ".";

  postUnpack = ''
      mv ldc-v${version}-src/* .

      mv druntime-ldc-v${version}-src/* runtime/druntime

      mv phobos-ldc-v${version}-src/* runtime/phobos

      mv dmd-testsuite-ldc-v${version}-src/* tests/d2/dmd-testsuite

      # Remove cppa test for now because it doesn't work.
      rm tests/d2/dmd-testsuite/runnable/cppa.d
      rm tests/d2/dmd-testsuite/runnable/extra-files/cppb.cpp
  '';

  postPatch = ''
      substituteInPlace runtime/phobos/std/net/curl.d \
          --replace libcurl.so ${curl.out}/lib/libcurl.so

      # Ugly hack to fix the hardcoded path to zoneinfo in the source file.
      # https://issues.dlang.org/show_bug.cgi?id=15391
      substituteInPlace runtime/phobos/std/datetime.d \
          --replace /usr/share/zoneinfo/ ${tzdata}/share/zoneinfo/
  ''

  + stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace driver/tool.cpp \
          --replace "gcc" "clang"
  '';

  nativeBuildInputs = [ cmake llvm dmd python lit gdb unzip ]

  ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    Foundation
  ]);

  buildInputs = [ curl tzdata stdenv.cc ];

  preConfigure = ''
    cmakeFlagsArray=("-DINCLUDE_INSTALL_DIR=$out/include/dlang/ldc")
  '';

  postConfigure = ''
    export DMD=$PWD/bin/ldc2
  '';

  makeFlags = [ "DMD=$DMD" ];

  # disable check phase because some tests are not working with sandboxing
  doCheck = false;

  checkPhase = ''
      ctest -j $NIX_BUILD_CORES -V DMD=$DMD
  '';

  meta = with stdenv.lib; {
    description = "The LLVM-based D compiler";
    homepage = https://github.com/ldc-developers/ldc;
    # from https://github.com/ldc-developers/ldc/blob/master/LICENSE
    license = with licenses; [ bsd3 boost mit ncsa gpl2Plus ];
    maintainers = with maintainers; [ ThomasMader ];
    platforms = platforms.unix;
  };
}
