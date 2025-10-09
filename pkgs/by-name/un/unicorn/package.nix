{
  lib,
  stdenv,
  cctools,
  cmake,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = "unicorn";
    tag = version;
    hash = "sha256-jEQXjYlLUdKrKPL4XfSbixn2KWJlNG7IYQveF4jDgl4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  # Ensure the linker is using atomic when compiling for RISC-V, otherwise fails
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isRiscV "-latomic";

  cmakeFlags = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Some x86 tests are interrupted by signal 10
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;test_x86"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "https://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
    ];
  };
}
