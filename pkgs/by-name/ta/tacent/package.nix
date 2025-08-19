{
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tacent";
  version = "0.8.18";

  src = fetchFromGitHub {
    owner = "bluescan";
    repo = "tacent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z8VuJS8OaVw5CeO/udvBEmcURKIy1oWVYUv6Ai8lTI8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
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
