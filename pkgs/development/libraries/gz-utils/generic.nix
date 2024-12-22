{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-utils";
  inherit version;

  src = fetchFromGitHub rec {
    owner = "gazebosim";
    repo = "gz-utils";
    rev = "${
      if lib.versionAtLeast finalAttrs.version "2.0.0" then "gz-utils" else "ignition-utils"
    }${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [
    cmake
    gz-cmake
  ];

  meta = {
    homepage = "https://gazebosim.org/libs/utils";
    description = "Classes and functions for robot applications";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
