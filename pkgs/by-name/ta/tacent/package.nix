{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  libx11,
  libxcb,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tacent";
  version = "0.8.18-unstable-2025-10-12";

  src = fetchFromGitHub {
    owner = "bluescan";
    repo = "tacent";
    rev = "13e08f388681e31a64b6d55c5a4667b7554e3e96";
    hash = "sha256-zePiqdjS5y9OPpZfMiXjlV3vKjO/YN1xs7fQuNGjQMc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    libx11
    libxcb
  ];

  meta = {
    description = "C++ library providing linear algebra and various utility functions";
    longDescription = ''
      A C++ library implementing linear algebra, text and file IO, UTF-N conversions,
      containers, image loading/saving, image quantization/filtering, command-line parsing, etc.
    '';
    homepage = "https://github.com/bluescan/tacent";
    changelog = "https://github.com/bluescan/tacent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ PopeRigby ];
    platforms = lib.platforms.linux;
    badPlatforms = [
      # /build/source/UnitTests/Src/UnitTests.cpp:149:15: error: 'Rule' is not a member of 'tUnitTest'
      "aarch64-linux"
    ];
  };
})
