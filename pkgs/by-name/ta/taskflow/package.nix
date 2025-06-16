{
  cmake,
  doctest,
  fetchFromGitHub,
  lib,
  replaceVars,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taskflow";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "taskflow";
    repo = "taskflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s0A8zJoq0VfmAks9h4v63J7tPX5JnlNTzJJMilzc5yM=";
  };

  patches = [
    (replaceVars ./unvendor-doctest.patch {
      inherit doctest;
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
