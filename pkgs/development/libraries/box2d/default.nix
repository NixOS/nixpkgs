{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGLU,
  libGL,
  freeglut,
  libX11,
  libXcursor,
  libXinerama,
  libXrandr,
  xorgproto,
  libXi,
  pkg-config,
  Carbon,
  Cocoa,
  Kernel,
  OpenGL,
  settingsFile ? "include/box2d/b2_settings.h",
}:

let
  inherit (lib) cmakeBool optionals;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cL8L+WSTcswj+Bwy8kSOwuEqLyWEM6xa/j/94aBiSck=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      libGLU
      libGL
      freeglut
      libX11
      libXcursor
      libXinerama
      libXrandr
      xorgproto
      libXi
    ]
    ++ optionals stdenv.isDarwin [
      Carbon
      Cocoa
      Kernel
      OpenGL
    ];

  cmakeFlags = [
    (cmakeBool "BOX2D_BUILD_UNIT_TESTS" finalAttrs.doCheck)
  ];

  prePatch = ''
    substituteInPlace ${settingsFile}  \
      --replace-fail 'b2_maxPolygonVertices	8' 'b2_maxPolygonVertices	15'
  '';

  # tests are broken on 2.4.1 and 2.3.x doesn't have tests: https://github.com/erincatto/box2d/issues/677
  doCheck = lib.versionAtLeast finalAttrs.version "2.4.2";

  meta = with lib; {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
})
