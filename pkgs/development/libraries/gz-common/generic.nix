{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  gz-cmake,
  gz-math,
  gz-utils,
  libuuid,
  tinyxml-2,
  freeimage,
  gts,
  ffmpeg,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-common";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-common";
    tag = "${
      if lib.versionAtLeast finalAttrs.version "5.0.0" then "gz-common" else "ignition-common"
    }${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gz-math
    gz-utils
    tinyxml-2
    gts
    freeimage # >:(
    ffmpeg
  ];

  # TODO: Do these really need to be propagated?
  propagatedNativeBuildInputs = [ gz-cmake ];
  propagatedBuildInputs = [ libuuid ];

  meta = {
    homepage = "https://gazebosim.org/libs/common/";
    description = "Miscellaneous libraries for Gazebo";
    longDescription = ''
      Gazebo Common, a component of Gazebo, provides a set of libraries that cover many different use cases.
      An audio-visual library supports processing audio and video files,
      a graphics library can load a variety 3D mesh file formats into a generic in-memory representation,
      and the core library of Gazebo Common contains functionality that spans Base64 encoding/decoding to thread pools.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
