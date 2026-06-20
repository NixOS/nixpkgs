{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unicorn-angr";
  # Version must follow what angr requires
  version = "2.0.1.post1";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = "unicorn";
    tag = finalAttrs.version;
    hash = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isRiscV {
    # Ensure the linker is using atomic when compiling for RISC-V, otherwise fails
    NIX_LDFLAGS = "-latomic";
  };

  cmakeFlags = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Some x86 tests are interrupted by signal 10
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;test_x86"
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "https://www.unicorn-engine.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
