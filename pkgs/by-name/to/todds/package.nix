{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  fmt,
  hyperscan,
  ispc,
  opencv,
  tbb_2021_11,
}:
stdenv.mkDerivation rec {
  pname = "todds";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "todds-encoder";
    repo = "todds";
    rev = version;
    hash = "sha256-LMs8V1NacVgzXUrp6JVIo2Qh/wMpNCUjUbf13FD/7cI=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    fmt
    hyperscan
    opencv
    tbb_2021_11
    ispc
  ];

  meta = with lib; {
    description = "A CPU-based DDS encoder optimized for fast batch conversions with high encoding quality";
    homepage = "https://github.com/todds-encoder/todds";
    license = licenses.mpl20;
    maintainers = with maintainers; [vinnymeller];
    mainProgram = "todds";
    platforms = platforms.all;
  };
}
