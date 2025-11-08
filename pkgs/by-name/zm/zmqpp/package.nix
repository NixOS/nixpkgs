{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zmqpp";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "zmqpp";
    tag = "${finalAttrs.version}";
    hash = "sha256-UZyJpBEOf/Ys+i2tiBTjv4PlM5fHjjNLWuGhpgcmYyM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [ zeromq ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/zeromq/zmqpp";
    description = "C++ wrapper for czmq. Aims to be minimal, simple and consistent";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ chris-martin ];
  };
})
