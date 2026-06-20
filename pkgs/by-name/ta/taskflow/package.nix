{
  cmake,
  doctest,
  fetchFromGitHub,
  fetchpatch,
  lib,
  replaceVars,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taskflow";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "taskflow";
    repo = "taskflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cWnKA6tCsKRfkleBJ38NRP2ciJu4sHtyTS8y5bBTfcA=";
  };

  patches = [
    (replaceVars ./unvendor-doctest.patch {
      inherit doctest;
    })

    # https://github.com/taskflow/taskflow/pull/785
    # TODO: remove when updating to the next release
    (fetchpatch {
      name = "fix-brace-init-with-explicit-constructor-for-GCC-15";
      url = "https://github.com/taskflow/taskflow/commit/de7dfe30594cd1f98398095b970a8320734a2382.patch";
      hash = "sha256-Ecl7dFvf2HDslv/5IHR5J2PYcRCN3EA4GahxOzcUS4g=";
    })

    # Vendored from #786 as it does not apply cleanly on top of v0.4.0
    # https://github.com/taskflow/taskflow/pull/786
    # TODO: remove when updating to the next release
    ./add-pkg-config-support.patch
  ];

  postPatch = ''
    rm -r 3rd-party

    # tries to use x86 intrinsics on aarch64-darwin
    sed -i '/^#if __has_include (<immintrin\.h>)/,/^#endif/d' taskflow/utility/os.hpp
  '';

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # FIXME remove once Taskflow is updated to 4.0.0
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "20")
    # building the tests implies running them in the buildPhase
    (lib.cmakeBool "TF_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  meta = {
    description = "General-purpose Parallel and Heterogeneous Task Programming System";
    homepage = "https://taskflow.github.io/";
    changelog =
      let
        release = lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version;
      in
      "https://taskflow.github.io/taskflow/release-${release}.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
