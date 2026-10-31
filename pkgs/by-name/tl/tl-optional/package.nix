{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tl-optional";
  version = "1.1.0";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "TartanLlama";
    repo = "optional";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WPTXTQmzJjAIJI1zM6svZZTO8gP/jt5xDHHRCCu9cmI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "OPTIONAL_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    # avoid FetchContent reaching out to the network for Catch2 at configure time
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CATCH2" "${catch2.src}")
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++11/14/17 std::optional with functional-style extensions and reference support";
    homepage = "https://tl.tartanllama.xyz/en/latest/api/optional.html";
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
