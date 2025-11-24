{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "unicorn-angr";
  # Version must follow what angr requires
  version = "2.0.1.post1";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = "unicorn";
    tag = version;
    hash = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # Ensure the linker is using atomic when compiling for RISC-V, otherwise fails
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isRiscV "-latomic";

  cmakeFlags = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Some x86 tests are interrupted by signal 10
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;test_x86"
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "https://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
