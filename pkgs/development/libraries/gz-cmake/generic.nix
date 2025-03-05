{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
}:

{
  version,
  hash ? lib.fakeHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "${if lib.versionAtLeast finalAttrs.version "3.0.0" then "gz-cmake" else "ignition-cmake"}${
      if lib.versions.major finalAttrs.version != "0" then lib.versions.major finalAttrs.version else ""
    }_${finalAttrs.version}";
    inherit hash;
  };

  nativeBuildInputs = [ cmake ];
  # pkg-config is needed to use some CMake modules in this package
  # TODO: Does this really need to be propagated?
  propagatedBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://gazebosim.org/libs/cmake";
    description = "A set of CMake modules that are used by the C++-based Gazebo projects. ";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandapip1
      lopsided98
    ];
    platforms = lib.platforms.all;
  };
})
