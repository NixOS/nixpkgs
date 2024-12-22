{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  gz-utils,
  eigen,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-math";
  inherit version;

  src = fetchFromGitHub rec {
    owner = "gazebosim";
    repo = "gz-math";
    rev = "refs/tags/${
      if lib.versionAtLeast finalAttrs.version "7.0.0" then "gz-math" else "ignition-math"
    }${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [
    cmake
    gz-cmake
  ];
  buildInputs = [
    gz-utils
    eigen
  ];

  meta = {
    homepage = "https://gazebosim.org/libs/math";
    description = "General purpose math library for robot applications. ";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
