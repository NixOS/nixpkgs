{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
, libpng
, libjpeg
, libGL
, libX11
, libXxf86vm
, withTouchSupport ? false
, libXi
, libXext
, Cocoa
, Kernel
}:
stdenv.mkDerivation rec {
  pname = "irrlichtmt";
  version = "1.9.0mt4";

  src = fetchFromGitHub {
    owner = "minetest";
    repo = "irrlicht";
    rev = version;
    sha256 = "sha256-YlXn9LrfGkjdb8+zQGDgrInolUYj9nVSF2AXWFpEEkw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  # https://github.com/minetest/minetest/pull/10729
  postPatch = lib.optionalString withTouchSupport ''
    substituteInPlace include/IrrCompileConfig.h \
      --replace '//#define _IRR_LINUX_X11_XINPUT2_' '#define _IRR_LINUX_X11_XINPUT2_'
  '';

  buildInputs = [
    zlib
    libpng
    libjpeg
    libGL
    libX11
    libXxf86vm
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
