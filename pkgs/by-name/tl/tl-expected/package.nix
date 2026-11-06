{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tl-expected";
  version = "1.3.1";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "expected";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+9M1++ZYaZNJGjEoI6+J8565R2wlznoDWW8MPrmCMoU=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "EXPECTED_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    # avoid FetchContent reaching out to the network for Catch2 at configure time
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CATCH2" "${catch2.src}")
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++11/14/17 std::expected with functional-style extensions";
    homepage = "https://tl.tartanllama.xyz/en/latest/api/expected.html";
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
