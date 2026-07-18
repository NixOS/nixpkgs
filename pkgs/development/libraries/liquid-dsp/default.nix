{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  autoreconfHook,
  autoSignDarwinBinariesHook,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "liquid-dsp";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "sha256-IvWtoXuuIvpJfY4cyRUsPHgax2/aytYShSdxEStiPYI=";
  };

  cmakeFlags = [
    # Prevent native cpu arch from leaking into binaries.
    (lib.cmakeBool "ENABLE_SIMD" false)
    (lib.cmakeBool "FIND_SIMD" false)
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    autoSignDarwinBinariesHook
    fixDarwinDylibNames
  ];

  patches = [
    ./fix-cmake-pc-paths.patch
    ./include-stdarg.patch
  ];

  doCheck = true;

  meta = {
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ iank ];
  };
}
