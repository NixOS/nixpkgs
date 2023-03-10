{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
, libpng
, libjpeg
, libGL
, libX11
, withTouchSupport ? false
, libXi
, libXext
, Cocoa
, Kernel
}:
stdenv.mkDerivation rec {
  pname = "irrlichtmt";
  version = "1.9.0mt8";

  src = fetchFromGitHub {
    owner = "minetest";
    repo = "irrlicht";
    rev = version;
    sha256 = "sha256-bwpALhBk16KugYqKuN57M3t5Ba7rdyrYWn/iBoi8hpg=";
  };

  nativeBuildInputs = [
    cmake
  ];

  # https://github.com/minetest/minetest/pull/10729
  postPatch = lib.optionalString (!withTouchSupport) ''
    sed -i '1i #define NO_IRR_LINUX_X11_XINPUT2_' include/IrrCompileConfig.h

    # HACK: Fix mistake in build script
    sed -i '/''${X11_Xi_LIB}/d' source/Irrlicht/CMakeLists.txt
  '';

  buildInputs = [
    zlib
    libpng
    libjpeg
    libGL
    libX11
  ] ++ lib.optionals withTouchSupport [
    libXi
    libXext
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
    Kernel
  ];

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://github.com/minetest/irrlicht";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ DeeUnderscore ];
    description = "Minetest project's fork of Irrlicht, a realtime 3D engine written in C++";
  };
}
