{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  libpng,
  libjpeg,
  libGL,
  libX11,
  libXi,
  libXext,
  Cocoa,
  Kernel,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "irrlichtmt";
  version = "1.9.0mt13";

  src = fetchFromGitHub {
    owner = "minetest";
    repo = "irrlicht";
    rev = finalAttrs.version;
    hash = "sha256-BlQd7zbpvQnxqLv3IaHWrXzJ1pJFbQQ3DNWDAj14/YY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      zlib
      libpng
      libjpeg
      libGL
      libX11
      libXi
      libXext
    ]
    ++ lib.optionals stdenv.isDarwin [
      Cocoa
      Kernel
    ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    homepage = "https://github.com/minetest/irrlicht";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ DeeUnderscore ];
    description = "Minetest project's fork of Irrlicht, a realtime 3D engine written in C++";
  };
})
