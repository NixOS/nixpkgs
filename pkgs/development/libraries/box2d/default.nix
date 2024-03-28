{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, libGLU
, libGL
, freeglut
, libX11
, xorgproto
, libXi
, pkg-config
, libXrandr
, libXinerama
, libXcursor
, Carbon
, Cocoa
, IOKit
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "box2d";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cL8L+WSTcswj+Bwy8kSOwuEqLyWEM6xa/j/94aBiSck=";
  };

  patches = [
    # for outdated doctest.h
    (fetchpatch {
      url = "https://github.com/erincatto/box2d/commit/cd2c28dba83e4f359d08aeb7b70afd9e35e39eda.patch";
      name = "update-doctest-version.patch";
      hash = "sha256-IoXl6xUGi1YU7u1f/HWvrurb/ADCAxoR7WyiGjifYDE=";
    })

    # for outdated doctest.h, see https://github.com/erincatto/box2d/issues/677
    (fetchpatch {
      url = "https://github.com/erincatto/box2d/commit/e76cf2d82792fbf915e42ae253f8a2ae252adbdf.patch";
      name = "update-doctest.patch";
      hash = "sha256-fBHM767bE02371FcJ+GXQyKcvbVYvcSh2jrC2WasBcE=";
    })

    # for outdated doctest.h, see https://github.com/erincatto/box2d/issues/732
    (fetchpatch {
      url = "https://github.com/erincatto/box2d/commit/87c98c6d39845e90439a192e8bc31befb56889d7.patch";
      name = "miscellaneous-fixes.patch";
      hash = "sha256-Smve1wK6t79WKi8ZcgDmkKrQ5A9u6/eZqlSlRe/4Aws=";
      includes = [ "unit-test/doctest.h" ];
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libGLU
    libGL
    freeglut
    libX11
    xorgproto
    libXi
    libXrandr
    libXinerama
    libXcursor
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Carbon
    Cocoa
    IOKit
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBOX2D_BUILD_TESTBED=OFF"
    (lib.cmakeBool "BOX2D_BUILD_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    bin/unit_test

    runHook postCheck
  '';

  meta = with lib; {
    description = "2D physics engine";
    homepage = "https://box2d.org/";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
})
