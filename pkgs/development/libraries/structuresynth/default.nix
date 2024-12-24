{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  qtbase,
  wrapQtAppsHook,
  libGL,
  libGLU,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "structuresynth";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "alemuntoni";
    repo = "structuresynth";
    rev = finalAttrs.version;
    hash = "sha256-uFz4WPwA586B/5p+DUJ/W8KzbHLBhLIwP6mySZJ1vPY=";
  };

  patches = [
    # This PR in 2 commits allow packaging of this project as standalone.
    # It was merged upstream, so those 2 patches can be removed on next release.
    (fetchpatch {
      name = "shared-lib.patch";
      url = "https://github.com/alemuntoni/StructureSynth/pull/1/commits/fdb87c55a03c6a0faa4335de5d29f0fb547b6102.patch";
      hash = "sha256-/66x8HGyNhGwoxsbV+QIRFYQNuFSHYXNYkJzAn4jyJI=";
    })
    (fetchpatch {
      name = "install-project.patch";
      url = "https://github.com/alemuntoni/StructureSynth/pull/1/commits/f96a90f6a4c60e9e0316edd20ea77674a2b764a7.patch";
      hash = "sha256-cSZAL1N2/Gd0x+9UkTUQxqVlb2m2MM8AA1Zzlo6S35w=";
    })
  ];

  outputs = [
    "dev"
    "out"
  ];

  buildInputs = [
    libGL
    libGLU
    qtbase
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Generate 3D structures by specifying a design grammar";
    homepage = "https://github.com/alemuntoni/StructureSynth";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nim65s ];
  };
})
