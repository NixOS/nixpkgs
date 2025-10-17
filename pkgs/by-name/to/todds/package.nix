{
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  ispc,
  boost,
  fmt,
  hyperscan,
  opencv,
  onetbb,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "todds";
  version = "0.4.1";

  patches = [ ./TBB-version.patch ];

  src = fetchFromGitHub {
    owner = "todds-encoder";
    repo = "todds";
    tag = finalAttrs.version;
    hash = "sha256-nyYFYym9ZZskkaTPV30+QavdqpvVopnIXXZC6zkeu7c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    ispc
  ];

  buildInputs = [
    boost
    fmt
    hyperscan
    opencv
    onetbb
  ];

  strictDeps = true;

  meta = {
    description = "CPU-based DDS encoder optimized for fast batch conversions with high encoding quality";
    homepage = "https://github.com/todds-encoder/todds";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ weirdrock ];
    mainProgram = "todds";
    platforms = lib.platforms.linux;
  };
})
