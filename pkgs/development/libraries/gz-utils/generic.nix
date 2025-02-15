{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cli11,
  cppcheck,
  doxygen,
  gz-cmake,
  spdlog,
  python3,
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
    tag = "${
      if lib.versionAtLeast finalAttrs.version "2.0.0" then "gz-utils" else "ignition-utils"
    }${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    inherit hash;
  };

  buildInputs = [
    cli11
    python3
  ];
  nativeBuildInputs = [
    cmake
    gz-cmake
    doxygen
    cppcheck
  ];

  propagatedBuildInputs = [ spdlog ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" true)
    (lib.cmakeFeature "CMAKE_POLICY_DEFAULT_CMP0177" "NEW")
  ];

  # TODO: It looks like this isn't being run?
  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

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
