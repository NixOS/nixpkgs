{ lib
, stdenv
, fetchFromGitHub
, cmake
, libGLU
, libGL
, libglut
, libX11
, libXcursor
, libXinerama
, libXrandr
, xorgproto
, libXi
, pkg-config
, Carbon
, Cocoa
, Kernel
, OpenGL
, settingsFile ? "include/box2d/b2_settings.h"
}:

let
  inherit (lib) cmakeBool optionals;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yvhpgiZpjTPeSY7Ma1bh4LwIokUUKB10v2WHlamL9D8=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libGLU
    libGL
    libglut
    libX11
    libXcursor
    libXinerama
    libXrandr
    xorgproto
    libXi
  ] ++ optionals stdenv.hostPlatform.isDarwin [
    Carbon Cocoa Kernel OpenGL
  ];

  cmakeFlags = [
    (cmakeBool "BOX2D_BUILD_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  prePatch = ''
    substituteInPlace ${settingsFile}  \
      --replace-fail 'b2_maxPolygonVertices	8' 'b2_maxPolygonVertices	15'
  '';

  # tests are broken on 2.4.2 and 2.3.x doesn't have tests: https://github.com/erincatto/box2d/issues/677
  doCheck = lib.versionAtLeast finalAttrs.version "2.4.2";

  meta = with lib; {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
})
