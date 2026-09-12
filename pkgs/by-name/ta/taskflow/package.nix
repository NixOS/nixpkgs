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
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "taskflow";
    repo = "taskflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IxorLV5qQ8veFiwRka8k5oMR51KTUn10MbCIYNVToLk=";
  };

  patches = [
    (replaceVars ./unvendor-doctest.patch {
      inherit doctest;
    })

    # GCC 16 has a regression in std::inclusive_scan where it modifies the
    # input data instead of leaving it unchanged, causing some incorrect
    # behavior and broken tests within taskflow. To work around this, Debian
    # reimplemented equivalent correct behavior in one case and copied the
    # input in another as appropriate. We adopt their approach to work around
    # this regression.
    # gcc bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=126604
    # debian bug: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1133642
    # taskflow issue: https://github.com/taskflow/taskflow/issues/809
    (fetchpatch {
      name = "gcc16-inclusive-scan-regression.patch";
      url = "https://salsa.debian.org/debian/taskflow/-/raw/039540a03c90cc825ce588f7ffae70db5472428f/debian/patches/fix-gcc16-inclusive-scan-move.patch";
      hash = "sha256-A8dUYKtjvvHAOrFGzDjat2hUHO1zoMbfdNnFJLZZbL0=";
    })
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
