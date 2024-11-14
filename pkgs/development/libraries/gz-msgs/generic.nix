{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  tinyxml-2,
  protobuf,
  gz-cmake,
  gz-math,
  gz-utils,
  python3,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-msgs";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-msgs";
    tag = "${
      if lib.versionAtLeast finalAttrs.version "9.0.0" then "gz-msgs" else "ignition-msgs"
    }${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [ cmake ];

  # TODO: More propagated inputs. Is this necessary?
  propagatedNativeBuildInputs = [ gz-cmake ];
  propagatedBuildInputs = [
    protobuf
    gz-math
    gz-utils
    tinyxml-2
    python3
  ];

  meta = {
    homepage = "https://gazebosim.org/libs/msgs";
    description = "Protobuf messages and functions for robot applications.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
